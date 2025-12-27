--- ! bản nháp, cần kiểm tra kỹ trước khi nộp


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
);

-- primary_contact special constraint
ALTER TABLE partner
ADD CONSTRAINT fk_primary_contact
FOREIGN KEY (id, primary_contact_id)
REFERENCES contact_point(partner_id, id);

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
