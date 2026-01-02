-- ! bản nháp, ko sử dụng để nộp

-- ! lưu ý xóa đoạn này trước khi sử dụng cho schema chính và trước khi nộp
DROP DATABASE IF EXISTS test;
CREATE DATABASE test;
USE test;
-- ! ----------------------------------------------------------------------


-- =========================
-- ORGANIZATION UNIT
-- =========================
CREATE TABLE organization_unit (
    id INT PRIMARY KEY AUTO_INCREMENT,
    unit_scope ENUM('school/university', 'faculty', 'lab/center') NOT NULL,
    name VARCHAR(150) NOT NULL,
    established_date DATE
);

-- =========================
-- PARTNER
-- =========================
CREATE TABLE partner (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type ENUM('person', 'organization') NOT NULL,
    name VARCHAR(150) NOT NULL,
    status ENUM('prospect', 'active', 'inactive') NOT NULL,
    website VARCHAR(255),
    tax_code VARCHAR(20),
    industry VARCHAR(100),
    notes TEXT,
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
    name VARCHAR(100),
    email VARCHAR(255),
    phone VARCHAR(20),
    title VARCHAR(50),
    PRIMARY KEY (id),
    UNIQUE (partner_id, id), -- constraint for composite foreign key usage at primary_contact
    FOREIGN KEY (partner_id) REFERENCES partner(id) ON DELETE CASCADE
);

-- primary_contact special constraint
CREATE TABLE primary_contact (
    partner_id INT PRIMARY KEY,
    contact_id INT NOT NULL,
    FOREIGN KEY (partner_id, contact_id)
        REFERENCES contact_point(partner_id, id)
        ON DELETE CASCADE
);

-- =========================
-- AGREEMENT
-- =========================
CREATE TABLE agreement (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    type ENUM('MoU', 'contracts', 'LoI') NOT NULL,
    start_date DATE,
    end_date DATE,
    status ENUM('draft', 'signed', 'expired', 'terminated') NOT NULL,
    reference_uri VARCHAR(255),
    partner_id INT NOT NULL,
    org_unit_id INT NOT NULL,
    FOREIGN KEY (partner_id) REFERENCES partner(id),
    FOREIGN KEY (org_unit_id) REFERENCES organization_unit(id),
    CONSTRAINT chk_agreement_dates CHECK (start_date <= end_date)
);

-- =========================
-- AFFILIATE (relationship with attribute)
-- =========================
CREATE TABLE affiliate (
    organization_unit_id INT,
    partner_id INT,
    affiliated_since DATE,
    PRIMARY KEY (organization_unit_id, partner_id),
    FOREIGN KEY (organization_unit_id) REFERENCES organization_unit(id) ON DELETE CASCADE,
    FOREIGN KEY (partner_id) REFERENCES partner(id) ON DELETE CASCADE
);

-- =========================
-- COLLABORATION EVENT
-- =========================
CREATE TABLE collaboration_event (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
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
    organizer_id INT NOT NULL,
    FOREIGN KEY (organizer_id) REFERENCES organization_unit(id),
    FOREIGN KEY (partner_id) REFERENCES partner(id),
    CONSTRAINT chk_event_dates CHECK (start_time <= end_time)
);

-- =========================
-- CONTRIBUTION
-- =========================
CREATE TABLE contribution (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type ENUM('cash', 'in-kind') NOT NULL,
    description TEXT,
    estimated_monetary_value DECIMAL(12,2) NOT NULL DEFAULT 0,
    contribution_date DATE,
    notes TEXT,
    partner_id INT NOT NULL,
    event_id INT,
    CONSTRAINT chk_contribution_value_positive CHECK (estimated_monetary_value >= 0),
    FOREIGN KEY (partner_id) REFERENCES partner(id),
    FOREIGN KEY (event_id) REFERENCES collaboration_event(id)
);

-- =========================
-- INVOICE
-- =========================
-- partner who paid for the event is in collaboration_event table via partner_id
CREATE TABLE invoice (
    reference_number INT PRIMARY KEY AUTO_INCREMENT,
    issue_date DATE NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    status ENUM('unpaid', 'paid', 'cancelled') NOT NULL,
    event_id INT,
    FOREIGN KEY (event_id) REFERENCES collaboration_event(id),
    CONSTRAINT chk_invoice_amount_positive CHECK (amount >= 0)
);

-- =========================
-- PAYMENT
-- =========================
-- instructor allows each invoice can have at most one payment
CREATE TABLE payment (
    payment_reference INT PRIMARY KEY AUTO_INCREMENT,
    payment_date DATE NOT NULL,
    payment_method ENUM('cash', 'bank transfer', 'e-wallet') NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    invoice_reference_number INT UNIQUE,

    CONSTRAINT chk_payment_amount_positive CHECK (amount >= 0),
    FOREIGN KEY (invoice_reference_number)
        REFERENCES invoice(reference_number)
);

-- =========================
-- FEEDBACK (WEAK ENTITY)
-- =========================
-- Each collaboration event can receive at most one feedback from the same rater
CREATE TABLE feedback (
    event_id INT NOT NULL,
    email VARCHAR(255) NOT NULL,
    rater_name VARCHAR(100) NOT NULL,
    rating INT NOT NULL,
    comments TEXT,
    feedback_date DATE NOT NULL,
    CONSTRAINT chk_rating_range CHECK (rating BETWEEN 1 AND 5),
    PRIMARY KEY (event_id, email),
    FOREIGN KEY (event_id) REFERENCES collaboration_event(id) ON DELETE CASCADE
);
