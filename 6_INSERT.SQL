USE test;

-- CLEAN UP
-- ----------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE payment;
TRUNCATE TABLE invoice;
TRUNCATE TABLE feedback;
TRUNCATE TABLE contribution;
TRUNCATE TABLE collaboration_event;
TRUNCATE TABLE affiliate;
TRUNCATE TABLE agreement;
TRUNCATE TABLE primary_contact;
TRUNCATE TABLE contact_point;
TRUNCATE TABLE partner;
TRUNCATE TABLE organization_unit;
SET FOREIGN_KEY_CHECKS = 1;

-- Insert ORGANIZATION UNITS
-- ----------------------------------------------------------
INSERT INTO organization_unit (id, unit_scope, name, established_date) VALUES
(1, 'school/university', 'Hanoi University of Science and Technology (HUST)', '1956-03-06'),
(2, 'faculty', 'School of Information and Communication Technology (SoICT)', '2022-12-01'),
(3, 'faculty', 'School of Electrical and Electronics Engineering (SEEE)', '2022-12-01'),
(4, 'faculty', 'School of Applied Mathematics and Informatics (SAMI)', '2023-12-01'),
(5, 'lab/center', 'International Research Center for AI (BK.AI)', '2018-01-01'),
(6, 'lab/center', 'Center for Business Cooperation', '2010-06-20');

-- Insert PARTNERS (10 Partners)
-- ----------------------------------------------------------
INSERT INTO partner (id, type, name, status, website, tax_code, industry, notes) VALUES
(1, 'organization', 'FPT Software', 'active', 'https://fpt-software.com', '0101234567', 'IT & Software', 'Strategic partner'),
(2, 'organization', 'Viettel Group', 'active', 'https://viettel.com.vn', '0109876543', 'Telecommunications', 'Scholarship provider'),
(3, 'organization', 'Samsung R&D', 'active', 'https://research.samsung.com', '0203040506', 'Electronics', 'Internship host'),
(4, 'organization', 'Vingroup Big Data', 'prospect', 'https://vinbigdata.org', '0304050607', 'AI & Data Science', NULL),
(5, 'organization', 'TopCV Vietnam', 'active', 'https://topcv.vn', '0405060708', 'Recruitment', 'Career fair sponsor'),
(6, 'organization', 'Sun Asterisk', 'inactive', 'https://sun-asterisk.com', '0506070809', 'Software Outsourcing', NULL),
(7, 'organization', 'MISA JSC', 'active', 'https://misa.vn', '0607080910', 'Accounting Software', NULL),
(8, 'person', 'Prof. Nguyen Van A', 'active', 'https://scholar.google.com/nva', NULL, 'Education', 'Alumni, Guest Lecturer'),
(9, 'person', 'Dr. Peter Smith', 'prospect', NULL, NULL, 'AI Researcher', 'Visiting Professor from US'),
(10, 'person', 'Ms. Tran Thi B', 'active', NULL, NULL, 'HR Consultant', 'Soft skill trainer');

-- Insert CONTACT POINTS
-- ----------------------------------------------------------
INSERT INTO contact_point (id, partner_id, name, email, phone, title) VALUES
-- Primary Contacts
(1, 1, 'Nguyen Tuan Minh', 'minhnt@fpt.com', '0901111222', 'HR Director'),
(2, 2, 'Le Thi Lan', 'lanlt@viettel.com.vn', '0902222333', 'Technical Lead'),
(3, 3, 'Park Ji Sung', 'p.jisung@samsung.com', '0903333444', 'R&D Manager'),
(4, 8, 'Nguyen Van A', 'nva.prof@gmail.com', '0908888999', 'Professor'),
-- Secondary Contacts
(5, 1, 'Pham Van Talent', 'talent@fpt.com', '0905555666', 'Recruitment Lead'),
(6, 2, 'Nguyen Van Sales', 'sales@viettel.com', '0907777888', 'Account Manager');

-- Link Primary Contacts
INSERT INTO primary_contact (partner_id, contact_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(8, 4);

-- Insert AGREEMENTS (NEW DATA - Added to match DDL)
-- ----------------------------------------------------------
INSERT INTO agreement (title, type, start_date, end_date, status, reference_uri, partner_id, org_unit_id) VALUES
-- 1. FPT Software (Partner ID 1) - Web URI .example
('Strategic Partnership 2024-2029', 'MoU', '2024-01-01', '2029-01-01', 'signed', 'https://doc.fpt-software.com.example/legal/hust/mou-2024-signed.pdf', 1, 1),
-- 2. Samsung R&D (Partner ID 3) - Web URI .example
('R&D Cooperation Contract', 'contracts', '2023-06-01', '2024-06-01', 'signed', 'https://research.samsung.com.example/partners/soict/contract-rd-vfinal.docx', 3, 2),
-- 3. Viettel Group (Partner ID 2) - Local File Protocol (file:///)
('Scholarship Fund Agreement', 'MoU', '2022-09-01', '2025-09-01', 'signed', 'file:///D:/Viettel_Corp/CSR_Dept/Scholarships/HUST_SEEE_2022_Signed.pdf', 2, 3),
-- 4. Dr. Peter Smith (Partner ID 9) - Personal Cloud Link .example
('Visiting Professor Contract', 'contracts', '2024-08-01', '2024-12-31', 'expired', 'https://drive.peter-smith-academic.net.example/share/contracts/hust-visiting-2024.pdf', 9, 5),
-- 5. TopCV (Partner ID 5) - Internal System Link .example
('Letter of Intent for Recruitment', 'LoI', '2024-01-01', '2024-12-31', 'draft', 'https://intranet.topcv.vn.example/legal-dept/loi/hust-recruitment-draft-v1.pdf', 5, 6);


-- Insert AFFILIATES
-- ----------------------------------------------------------
INSERT INTO affiliate (organization_unit_id, partner_id, affiliated_since) VALUES
(2, 1, '2015-01-01'), -- SoICT - FPT
(2, 3, '2018-05-20'), -- SoICT - Samsung
(3, 2, '2016-03-15'), -- SEEE - Viettel
(5, 4, '2020-01-10'), -- BK.AI - VinBigData
(5, 3, '2019-08-01'), -- BK.AI - Samsung
(4, 8, '1990-09-05'); -- SAMI - Prof A

-- Insert COLLABORATION EVENTS
-- ----------------------------------------------------------
INSERT INTO collaboration_event (id, title, type, location, start_time, end_time, number_of_students, partner_id, organizer_id) VALUES
(1, 'FPT Career Tour 2024', 'guest lectures', 'Hall C2', '2024-03-10 09:00:00', '2024-03-10 12:00:00', 200, 1, 2),  -- Org by SoICT
(2, 'Viettel Future Gen Scholarship', 'seminars', 'Ta Quang Buu Hall', '2024-04-15 14:00:00', '2024-04-15 16:00:00', 150, 2, 3), -- Org by SEEE
(3, 'Samsung Algorithms Workshop', 'workshops', 'Lab D9', '2024-05-20 08:00:00', '2024-05-20 17:00:00', 50, 3, 2),    -- Org by SoICT
(4, 'AI Hackathon with VinBigData', 'hackathons', 'Library Hall', '2024-06-01 08:00:00', '2024-06-02 20:00:00', 100, 4, 5), -- Org by BK.AI
(5, 'CV Writing Masterclass', 'workshops', 'Online Zoom', '2024-07-10 19:00:00', '2024-07-10 21:00:00', 300, 5, 6),       -- Org by Business Ctr
(6, 'Guest Lecture: Blockchain 101', 'guest lectures', 'Room D9-401', '2024-08-05 09:00:00', '2024-08-05 11:00:00', 80, 8, 4), -- Org by SAMI
(7, 'Joint Research: NLP for Vietnamese', 'joint research activities', 'AI Lab B1', '2024-01-01 00:00:00', '2024-12-31 00:00:00', 5, 8, 5), -- Org by BK.AI
(8, 'Soft Skills for Engineers', 'seminars', 'Hall C2', '2024-09-15 08:30:00', '2024-09-15 11:30:00', 120, 10, 6),        -- Org by Business Ctr
(9, 'MISA Code War', 'competitions', 'Online', '2024-10-10 08:00:00', '2024-10-10 17:00:00', 500, 7, 2),                 -- Org by SoICT
(10, 'Industry Talk: 5G Technology', 'guest lectures', 'Hall C2', '2024-11-20 14:00:00', '2024-11-20 16:00:00', 180, 2, 3); -- Org by SEEE

-- Insert CONTRIBUTIONS
-- ----------------------------------------------------------
INSERT INTO contribution (id, type, description, estimated_monetary_value, contribution_date, partner_id, event_id) VALUES
(1, 'cash', 'Sponsorship for Career Tour', 20000000.00, '2024-03-01', 1, 1),
(2, 'in-kind', '10 Scholarships vouchers', 50000000.00, '2024-04-10', 2, 2),
(3, 'in-kind', 'Training materials and lunch', 10000000.00, '2024-05-18', 3, 3),
(4, 'cash', 'Hackathon First Prize', 30000000.00, '2024-05-25', 4, 4),
(5, 'in-kind', 'Premium CV Accounts for students', 15000000.00, '2024-07-01', 5, 5),
(6, 'in-kind', 'Speaker time', 5000000.00, '2024-08-05', 8, 6),
(7, 'cash', 'Research Grant Phase 1', 100000000.00, '2024-01-15', 8, 7),
(8, 'cash', 'Hall rental support', 5000000.00, '2024-09-10', 10, 8),
(9, 'cash', 'Competition Platform Fee', 25000000.00, '2024-10-01', 7, 9),
(10, 'in-kind', 'Demo 5G Equipments', 80000000.00, '2024-11-15', 2, 10);

-- Insert INVOICES
-- ----------------------------------------------------------
INSERT INTO invoice (reference_number, issue_date, amount, status, event_id) VALUES
(1, '2024-03-05', 5000000.00, 'paid', 1),
(2, '2024-04-20', 2000000.00, 'paid', 2),
(3, '2024-05-25', 10000000.00, 'paid', 3),
(4, '2024-06-05', 15000000.00, 'paid', 4),
(5, '2024-07-15', 3000000.00, 'paid', 5),
(6, '2024-08-10', 1000000.00, 'cancelled', 6),
(7, '2024-02-01', 5000000.00, 'paid', 7),
(8, '2024-09-20', 2000000.00, 'unpaid', 8),
(9, '2024-10-15', 8000000.00, 'paid', 9),
(10, '2024-11-25', 5000000.00, 'paid', 10);

-- Insert PAYMENTS
-- ----------------------------------------------------------
INSERT INTO payment (payment_reference, payment_date, payment_method, amount, invoice_reference_number) VALUES
(1, '2024-03-06', 'bank transfer', 5000000.00, 1),
(2, '2024-04-21', 'bank transfer', 2000000.00, 2),
(3, '2024-05-26', 'bank transfer', 10000000.00, 3),
(4, '2024-06-06', 'bank transfer', 15000000.00, 4),
(5, '2024-07-16', 'e-wallet', 3000000.00, 5),
(6, '2024-08-11', 'cash', 1000000.00, 6),
(7, '2024-02-02', 'bank transfer', 5000000.00, 7),
(8, '2024-09-21', 'cash', 1000000.00, 8),
(9, '2024-10-16', 'bank transfer', 8000000.00, 9),
(10, '2024-11-26', 'bank transfer', 5000000.00, 10);

-- Insert FEEDBACK
-- ----------------------------------------------------------
INSERT INTO feedback (event_id, email, rater_name, rating, comments, feedback_date) VALUES
(1, 'anv.k66@sis.hust.edu.vn', 'Nguyen Van A - K66 HUST', 5, 'Very helpful', '2024-03-11'),
(1, 'blt.k67@sis.hust.edu.vn', 'Le Thi B - K67 HUST', 4, 'A bit crowded', '2024-03-11'),
(3, 'ctv.k65@sis.hust.edu.vn', 'Tran Van C - K65 HUST', 5, 'Challenging but excellent algorithms', '2024-05-21'),
(3, 'dpt.k68@sis.hust.edu.vn', 'Pham Thi D - K68 HUST', 3, 'Hard to understand', '2024-05-21'),
(4, 'leader.bkdev@soict.hust.edu.vn', 'Team BK-Dev - SoICT', 5, 'Professional organization', '2024-06-03'),
(5, 'ehv.k69@sis.hust.edu.vn', 'Hoang Van E - K69 HUST', 4, 'Learned how to write a proper CV', '2024-07-11'),
(10, 'fvt.k66@sis.hust.edu.vn', 'Vu Thi F - K66 HUST', 5, 'Excited for 5G', '2024-11-21');