SELECT * FROM bank_loan_data


-- OVERVIEW TAB
-- Total Loan Applications
SELECT COUNT(id) AS Total_Loan_Applications FROM bank_loan_data

--MTD Loan Applications
SELECT COUNT(id) AS MTD_Loan_Applications FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date)=2021


--MoM Applications
WITH monthly_totals AS (
    SELECT 
		MONTH(issue_date) AS month, -- Extract year and month
        SUM(loan_amount) AS total_applications
    FROM 
        bank_loan_data
    GROUP BY 
        MONTH(issue_date)
),
mom_calculation AS (
    SELECT 
        month,
        total_applications,
        LAG(total_applications) OVER (ORDER BY month) AS previous_month_applications,
        -- Calculate MoM growth percentage
        ROUND(
            (total_applications - LAG(total_applications) OVER (ORDER BY month)) 
            / NULLIF(LAG(total_applications) OVER (ORDER BY month), 0) * 100, 2
        ) AS mom_growth_percentage
    FROM 
        monthly_totals
)
SELECT 
    month,
    total_applications,
    previous_month_applications,
    mom_growth_percentage
FROM 
    mom_calculation;


-- Total funded amount
SELECT SUM(loan_amount) AS Total_funded_amount FROM bank_loan_data


-- MTD funded amount
SELECT SUM(loan_amount) AS MTD_total_funded_amount FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date)=2021


--Total Received amount 
SELECT SUM(total_payment) AS Total_received_amount FROM bank_loan_data

-- MTD received amount
SELECT SUM(total_payment) AS MTD_total_received_amount FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

--Average Interest Rate 
SELECT ROUND((AVG(int_rate) * 100), 2) AS Average_interest_rate FROM bank_loan_data

-- MTD Average Interest Rate

SELECT ROUND((AVG(int_rate) * 100), 2) AS MTD_average_interest_rate FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date)=2021

-- Debt-to-income ratio
SELECT ROUND((AVG(dti) * 100), 2) AS Debt_to_income FROM bank_loan_data

-- MTD Debt-to-income ratio
SELECT ROUND((AVG(dti) * 100), 2) AS MTD_Debt_to_income FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date)=2021


-- Performing Loans 
SELECT
	(COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100)
	/ COUNT(id) AS Perfoming_loans_percentage FROM  bank_loan_data

-- Peforming Loans Application
SELECT COUNT(id) AS Performing_Loans_Application FROM bank_loan_data 
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

-- Peforming Loans Funded Amount
SELECT SUM(loan_amount) AS Performing_Loans_Funded_Amount FROM bank_loan_data 
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

-- Peforming Loans Recieved Amount
SELECT SUM(total_payment) AS Performing_Loans_Recieved_Amount FROM bank_loan_data 
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

-- NonPerformig Loans 
SELECT
	(COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100)
	/ COUNT(id) AS Non_performing_loans_percentage FROM bank_loan_data

-- Number of Non_Performing_Loans_Application
SELECT COUNT(id) AS Non_Performing_Loans_Application FROM bank_loan_data 
WHERE loan_status = 'Charged Off' 

-- Non Peforming Loans Funded Amount
SELECT SUM(loan_amount) AS Non_Performing_Loans_Funded_Amount FROM bank_loan_data 
WHERE loan_status = 'Charged Off'

-- Non Peforming Loans Received Amount
SELECT SUM(total_payment) AS Non_Performing_Loans_Received_Amount FROM bank_loan_data 
WHERE loan_status = 'Charged Off'

-- Number of Active Loans
SELECT COUNT(id) AS	Active_Loans FROM bank_loan_data 
WHERE loan_status = 'Current' 

----- lOAN STATUS 

SELECT 
	loan_status,
	COUNT(id) AS Number_of_applications,
	SUM(total_payment) AS Total_Received_Amount,
	SUM(loan_amount) AS Total_Funded_Amount, 
	ROUND(AVG(int_rate) * 100,2) AS Interest_Rate, 
	ROUND(AVG(dti) * 100,2) AS DTI 
	FROM bank_loan_data

	GROUP BY loan_status

SELECT
	loan_status,
	SUM(total_payment) AS MTD_Total_Received_Amount,
	SUM(loan_amount) AS MTD_Total_Funded_Amount
	FROM bank_loan_data
	WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
	GROUP BY loan_status

 ---- Monthly Trends

 SELECT 
	MONTH(issue_date) AS month_number,
	DATENAME(MONTH, issue_date) As Month,
	COUNT(id) AS Number_of_applications,
	SUM(total_payment) AS Total_Received_Amount,
	SUM(loan_amount) AS Total_Funded_Amount
	FROM bank_loan_data
	GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date) 
	ORDER BY MONTH(issue_date)

---- Regional Trends
SELECT 
	address_state AS state,
	COUNT(id) AS Number_of_applications,
	SUM(total_payment) AS Total_Received_Amount,
	SUM(loan_amount) AS Total_Funded_Amount
	FROM bank_loan_data
	GROUP BY address_state
	ORDER BY address_state


---- emp_length  Trends
SELECT 
	emp_length AS employment_length,
	COUNT(id) AS Number_of_applications,
	SUM(total_payment) AS Total_Received_Amount,
	SUM(loan_amount) AS Total_Funded_Amount
	FROM bank_loan_data
	GROUP BY emp_length
	ORDER BY emp_length



---- Purpose  Trends
SELECT 
	purpose AS Purpose,
	COUNT(id) AS Number_of_applications,
	SUM(total_payment) AS Total_Received_Amount,
	SUM(loan_amount) AS Total_Funded_Amount
	FROM bank_loan_data
	GROUP BY purpose
	ORDER BY purpose

---- Home Ownership  Trends
SELECT 
	home_ownership AS Purpose,
	COUNT(id) AS Number_of_applications,
	SUM(total_payment) AS Total_Received_Amount,
	SUM(loan_amount) AS Total_Funded_Amount
	FROM bank_loan_data
	GROUP BY home_ownership
	ORDER BY home_ownership