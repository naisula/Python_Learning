-- total beneficiaries per partner
SELECT
    partner,
    SUM(
        CASE 
            WHEN beneficiary_type = 'Households' THEN beneficiaries * 6
            ELSE beneficiaries
        END
    ) AS total_individuals
FROM beneficiary_partner_data
GROUP BY partner;

-- villages served per partner
SELECT partner, COUNT(DISTINCT village) AS villages_served
FROM beneficiary_partner_data
GROUP BY partner;

-- average beneficiaries per village
SELECT village,
       AVG(
           CASE 
               WHEN beneficiary_type='Households' THEN beneficiaries*6
               ELSE beneficiaries
           END
       ) AS avg_beneficiaries
FROM beneficiary_partner_data
GROUP BY village;

-- partners > 5000 beneficiaries
SELECT partner,
       SUM(CASE WHEN beneficiary_type='Households' THEN beneficiaries*6 ELSE beneficiaries END) AS total
FROM beneficiary_partner_data
GROUP BY partner
HAVING total > 5000;

-- villages with multiple partners
SELECT village, COUNT(DISTINCT partner) AS partner_count
FROM beneficiary_partner_data
GROUP BY village
HAVING partner_count > 1;

-- coverage per village 
SELECT 
    v.village,
    v.total_population,
    SUM(
        CASE 
            WHEN b.beneficiary_type='Households' THEN b.beneficiaries*6
            ELSE b.beneficiaries
        END
    ) AS total_beneficiaries,
    SUM(
        CASE 
            WHEN b.beneficiary_type='Households' THEN b.beneficiaries*6
            ELSE b.beneficiaries
        END
    ) / v.total_population AS coverage
FROM village_locations v
LEFT JOIN beneficiary_partner_data b
ON v.village = b.village
GROUP BY v.village, v.total_population;

-- villages + partners
SELECT village AS location, partner
FROM beneficiary_partner_data

UNION

SELECT village, NULL
FROM village_locations;

-- villages above average coverage
SELECT village, coverage
FROM (
    SELECT v.village,
           SUM(CASE WHEN b.beneficiary_type='Households' THEN b.beneficiaries*6 ELSE b.beneficiaries END)/v.total_population AS coverage
    FROM village_locations v
    LEFT JOIN beneficiary_partner_data b ON v.village=b.village
    GROUP BY v.village, v.total_population
) x
WHERE coverage > (
    SELECT AVG(coverage) FROM (
        SELECT SUM(CASE WHEN beneficiary_type='Households' THEN beneficiaries*6 ELSE beneficiaries END)/v2.total_population AS coverage
        FROM village_locations v2
        LEFT JOIN beneficiary_partner_data b2 ON v2.village=b2.village
        GROUP BY v2.village, v2.total_population
    ) y
);

-- partners above average beneficiaries
SELECT partner, total
FROM (
    SELECT partner,
           SUM(CASE WHEN beneficiary_type='Households' THEN beneficiaries*6 ELSE beneficiaries END) AS total
    FROM beneficiary_partner_data
    GROUP BY partner
) p
WHERE total > (
    SELECT AVG(total) FROM (
        SELECT SUM(CASE WHEN beneficiary_type='Households' THEN beneficiaries*6 ELSE beneficiaries END) AS total
        FROM beneficiary_partner_data
        GROUP BY partner
    ) a
);

-- district level 
WITH district_data AS (
    SELECT 
        h.parent AS county,
        v.village,
        v.total_population,
        SUM(CASE WHEN b.beneficiary_type='Households' THEN b.beneficiaries*6 ELSE b.beneficiaries END) AS beneficiaries
    FROM jurisdiction_hierarchy h
    JOIN village_locations v ON h.name = v.village
    LEFT JOIN beneficiary_partner_data b ON v.village=b.village
    GROUP BY h.parent, v.village, v.total_population
)
SELECT *,
       beneficiaries / total_population AS coverage
FROM district_data;

-- rank districts
WITH district AS (
    SELECT 
        h.parent AS county,
        SUM(CASE WHEN b.beneficiary_type='Households' THEN b.beneficiaries*6 ELSE b.beneficiaries END) AS total_beneficiaries
    FROM jurisdiction_hierarchy h
    JOIN village_locations v ON h.name=v.village
    LEFT JOIN beneficiary_partner_data b ON v.village=b.village
    GROUP BY h.parent
)
SELECT *,
       RANK() OVER (ORDER BY total_beneficiaries DESC) AS rnk
FROM district;

-- partner ranking
SELECT partner,
       SUM(CASE WHEN beneficiary_type='Households' THEN beneficiaries*6 ELSE beneficiaries END) AS total,
       RANK() OVER (ORDER BY SUM(CASE WHEN beneficiary_type='Households' THEN beneficiaries*6 ELSE beneficiaries END) DESC) AS rnk
FROM beneficiary_partner_data
GROUP BY partner;

-- direct summary view
CREATE VIEW district_summary AS
SELECT 
    h.parent AS county,
    SUM(CASE WHEN b.beneficiary_type='Households' THEN b.beneficiaries*6 ELSE b.beneficiaries END) AS beneficiaries
FROM jurisdiction_hierarchy h
JOIN village_locations v ON h.name=v.village
LEFT JOIN beneficiary_partner_data b ON v.village=b.village
GROUP BY h.parent;

-- partner summary view
CREATE VIEW partner_summary AS
SELECT 
    partner,
    COUNT(DISTINCT village) AS villages_served,
    SUM(CASE WHEN beneficiary_type='Households' THEN beneficiaries*6 ELSE beneficiaries END) AS total_beneficiaries
FROM beneficiary_partner_data
GROUP BY partner;
-- triggers
DELIMITER $$

CREATE TRIGGER prevent_negative
BEFORE INSERT ON beneficiary_partner_data
FOR EACH ROW
BEGIN
    IF NEW.beneficiaries < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Negative beneficiaries not allowed';
    END IF;
END$$

DELIMITER ;

CREATE TABLE logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
DELIMITER $$

CREATE TRIGGER log_insert
AFTER INSERT ON beneficiary_partner_data
FOR EACH ROW
BEGIN
    INSERT INTO logs(message)
    VALUES (CONCAT('New record added for ', NEW.partner, ' in ', NEW.village));
END$$

DELIMITER ;

-- stored procedures
DELIMITER $$

CREATE PROCEDURE GetPartnerReport(IN p_name VARCHAR(30))
BEGIN
    SELECT partner,
           village,
           SUM(CASE WHEN beneficiary_type='Households' THEN beneficiaries*6 ELSE beneficiaries END) AS total
    FROM beneficiary_partner_data
    WHERE partner = p_name
    GROUP BY village;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE GetDistrictImpact(IN d_name VARCHAR(30))
BEGIN
    SELECT h.parent AS county,
           SUM(CASE WHEN b.beneficiary_type='Households' THEN b.beneficiaries*6 ELSE b.beneficiaries END) AS beneficiaries
    FROM jurisdiction_hierarchy h
    JOIN village_locations v ON h.name=v.village
    LEFT JOIN beneficiary_partner_data b ON v.village=b.village
    WHERE h.parent = d_name
    GROUP BY h.parent;
END$$

DELIMITER ;




















