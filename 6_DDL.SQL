-- ! bản nháp, cần kiểm tra kỹ trước khi nộp


-- =========================
-- ORGANIZATION UNIT
-- =========================
CREATE TABLE organization_unit (
    id INT PRIMARY KEY AUTO_INCREMENT,
    unit_scope ENUM('school/university', 'faculty', 'lab/center') NOT NULL,
    name VARCHAR(255) NOT NULL,
    established_date DATE
);

-- =========================
-- PARTNER
-- =========================
CREATE TABLE partner (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type ENUM('person', 'organization') NOT NULL,
    name VARCHAR(255) NOT NULL,
    status ENUM('prospect', 'active', 'inactive') NOT NULL,
    website VARCHAR(255),
    tax_code VARCHAR(100),
    industry VARCHAR(100),
    notes TEXT,
    primary_contact_id INT,
    CONSTRAINT chk_partner_tax_code
        CHECK (
            (type = 'organization' AND tax_code IS NOT NULL)
            OR
            (type = 'person' AND tax_code IS NULL)
        )
);

-- =========================
-- CONTACT POINT
-- =========================
CREATE TABLE contact_point (
    id INT AUTO_INCREMENT,
    partner_id INT NOT NULL,
    name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(50),
    title VARCHAR(100),
    PRIMARY KEY (id),
    UNIQUE (partner_id, id),
    FOREIGN KEY (partner_id) REFERENCES partner(id)
    ADD UNIQUE (partner_id, id)
);

-- primary_contact special constraint
-- phương pháp 1
-- dùng composite foreign key từ partner (id, primary_contact_id)
-- trong đó primary_contact_id tham chiếu đến contact_point.id như thường
-- nhưng bổ sung partner.id để đảm bảo ownership, tránh trỏ đến contact_point của partner khác
-- ưu điểm: đơn giản, nhẹ, gần với ERD conceptual model
-- nhược điểm gây circular reference -> insert/delete phải đúng thứ tự
ALTER TABLE partner
ADD CONSTRAINT fk_primary_contact
FOREIGN KEY (id, primary_contact_id)
REFERENCES contact_point(partner_id, id);
-- phương pháp 2
-- không dùng primary_contact_id vì gây circular reference
-- thay vào đó, dùng is_primary boolean trong contact_point
-- với điều kiện (partner_id, is_primary = true) là unique
-- có thể dùng trigger để enforce logic "một partner có thể có một primary contact"
-- ưu điểm: tránh circular reference
-- nhược điểm: hiệu năng và tạo trigger phức tạp, và hơi khó hiểu và hidden constraint so với ERD conceptual model

-- cách làm --
-- todo: tạo trigger đảm bảo mỗi partner chỉ có một contact_point với is_primary = true
--------------

-- phương pháp 3
-- tạo bảng junction primary_contact(partner_id, contact_id) với ràng buộc là subset của contact_point(partner_id, contact_id)
-- rằng buộc 1: primary_contact có FK (partner_id, contact_id) đến contact_point(partner_id, contact_id)
-- -- ràng buộc 1 đảm bảo primary_contact là subset của contact_point(partner_id, contact_id) -> giúp bảo đảm đúng ownsership
-- rằng buộc 2: 'partner_id là unique'
-- -- ràng buộc 2 đảm bảo mỗi partner chỉ có tối đa một primary contact
-- ưu điểm: tránh circular reference, rõ ràng ownership và ràng buộc hơn, và chuẩn hơn nhiều so với ERD đã vẽ
-- nhược điểm: thêm bảng, join nhiều hơn -> hiệu năng có thể kém hơn, phức tạp hơn ở bước query

-- cách làm --
-- CREATE TABLE primary_contact (
--     partner_id INT PRIMARY KEY,
--     contact_id INT NOT NULL,
--     FOREIGN KEY (partner_id, contact_id)
--         REFERENCES contact_point(partner_id, contact_id)
-- );
-- optional: Create view để query dễ hơn
-- CREATE VIEW partner_with_primary AS
-- SELECT
--     p.*,
--     cp.name AS primary_contact_name,
--     cp.email AS primary_contact_email,
--     cp.phone AS primary_contact_phone
-- FROM partner p
-- LEFT JOIN primary_contact pc ON p.id = pc.partner_id
-- LEFT JOIN contact_point cp ON pc.contact_id = cp.id;
--------------

-- phương pháp 4
-- giống phương pháp 3, nhưng dùng 2 bảng partner_primary_contact và partner_contact
-- không lưu partner_id trong contact_point
-- partner_contact là junction giữa partner và contact_point
-- partner_primary_contact là bảng subset của partner_contact
-- cơ chế ràng buộc subset y như phương pháp 3
-- ưu điểm: giống ERD nhất, nếu 1 người được phép làm nhiều partner thì đây là giải pháp duy nhất
-- nhược điểm: phức tạp hơn, overkill, thừa thãi trên thực tế và phương pháp 3 là đủ
-- ! bàn luận với team để chọn phương án phù hợp


-- =========================
-- AGREEMENT
-- =========================
CREATE TABLE agreement (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    type ENUM('MoU', 'contracts', 'LoI') NOT NULL,
    start_date DATE,
    end_date DATE,
    status ENUM('draft', 'signed', 'expired', 'terminated') NOT NULL,
    reference_uri VARCHAR(255),
    partner_id INT NOT NULL,
    org_unit_id INT NOT NULL,
    FOREIGN KEY (partner_id) REFERENCES partner(id),
    FOREIGN KEY (org_unit_id) REFERENCES organization_unit(id)
);

-- =========================
-- AFFILIATE (M-N with attribute)
-- =========================
CREATE TABLE affiliate (
    organization_unit_id INT,
    partner_id INT,
    affiliated_since DATE,
    PRIMARY KEY (organization_unit_id, partner_id),
    FOREIGN KEY (organization_unit_id) REFERENCES organization_unit(id),
    FOREIGN KEY (partner_id) REFERENCES partner(id)
);

-- =========================
-- COLLABORATION EVENT
-- =========================
CREATE TABLE collaboration_event (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    type ENUM(
        'seminars',
        'workshops',
        'competitions',
        'hackathons',
        'guest lectures',
        'joint research activities'
    ) NOT NULL,
    location VARCHAR(255),
    start_time DATETIME,
    end_time DATETIME,
    number_of_students INT,
    partner_id INT NOT NULL,
    FOREIGN KEY (partner_id) REFERENCES partner(id)
);

-- =========================
-- CONTRIBUTION
-- =========================
CREATE TABLE contribution (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type ENUM('cash', 'in-kind') NOT NULL,
    description TEXT,
    estimated_monetary_value DECIMAL(12,2),
    contribution_date DATE,
    notes TEXT,
    partner_id INT NOT NULL,
    event_id INT,
    FOREIGN KEY (partner_id) REFERENCES partner(id),
    FOREIGN KEY (event_id) REFERENCES collaboration_event(id)
);

-- =========================
-- INVOICE
-- =========================
CREATE TABLE invoice (
    reference_number INT PRIMARY KEY AUTO_INCREMENT,
    issue_date DATE,
    amount DECIMAL(12,2),
    status ENUM('unpaid', 'paid', 'cancelled') NOT NULL,
    event_id INT UNIQUE,
    FOREIGN KEY (event_id) REFERENCES collaboration_event(id)
);

-- =========================
-- PAYMENT
-- =========================
CREATE TABLE payment (
    payment_reference INT PRIMARY KEY AUTO_INCREMENT,
    payment_date DATE,
    payment_method ENUM('cash', 'bank transfer', 'e-wallet') NOT NULL,
    amount DECIMAL(12,2),
    partner_id INT NOT NULL,
    invoice_reference_number INT UNIQUE,
    FOREIGN KEY (partner_id) REFERENCES partner(id),
    FOREIGN KEY (invoice_reference_number)
        REFERENCES invoice(reference_number)
);

-- =========================
-- FEEDBACK (WEAK ENTITY)
-- =========================
CREATE TABLE feedback (
    event_id INT NOT NULL,
    rater_name VARCHAR(255) NOT NULL,
    rating INT,
    comments TEXT,
    feedback_date DATE,
    PRIMARY KEY (event_id, rater_name),
    FOREIGN KEY (event_id) REFERENCES collaboration_event(id)
);

-- Each collaboration event can receive at most one feedback from the same rater
