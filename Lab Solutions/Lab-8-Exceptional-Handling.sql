--Part – A 
--1. Handle Divide by Zero Error and Print message like: Error occurs that is - Divide by zero error.
BEGIN TRY
    SELECT 10 / 0 AS RESULT
END TRY
BEGIN CATCH
    PRINT 'Error occurs that is - Divide by zero error.';
END CATCH;
--2. Try to convert string to integer and handle the error using try…catch block. 
BEGIN TRY
    DECLARE @str VARCHAR(10) = 'ABC';
    DECLARE @num INT;

    SET @num = CAST(@str AS INT);
    PRINT @num;
END TRY
BEGIN CATCH
    PRINT 'Error: Cannot convert string to integer.';
END CATCH;
--3. Create a procedure that prints the sum of two numbers: take both numbers as integer & handle 
--exception with all error functions if any one enters string value in numbers otherwise print result.
GO
CREATE OR ALTER PROCEDURE PR_SUM
    @a VARCHAR(10),
    @b VARCHAR(10)
AS
BEGIN
    BEGIN TRY
        DECLARE @num1 INT, @num2 INT;

        SET @num1 = CAST(@a AS INT);
        SET @num2 = CAST(@b AS INT);

        PRINT 'Sum = ' + CAST(@num1 + @num2 AS VARCHAR);
    END TRY
    BEGIN CATCH
        PRINT 'Error: Invalid input. Please enter integers only.';
    END CATCH
END; 
GO

EXEC PR_SUM '10','20' 

EXEC PR_SUM '10','XYZ' --ERROR: Invalid input. Please enter integers only.
--4. Handle a Primary Key Violation while inserting data into student table and print the error details such 
--as the error message, error number, severity, and state. 
SELECT * FROM STUDENT
BEGIN TRY
    INSERT INTO STUDENT (StudentID,Name) VALUES(1,'DHRUV')
END TRY
BEGIN CATCH
 PRINT 'Error Message: ' + ERROR_MESSAGE();
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    PRINT 'Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR);
    PRINT 'State: ' + CAST(ERROR_STATE() AS VARCHAR);
END CATCH
--5. Throw custom exception using stored procedure which accepts StudentID as input & that throws 
--Error like no StudentID is available in database. 
GO
CREATE OR ALTER PROCEDURE PR_CHECK_STUDENT
    @StudentID INT
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM Student WHERE StudentID = @StudentID)
        THROW 50001, 'Error: StudentID not found in database.', 1;
    ELSE
        PRINT 'Student exists.';
END;
GO
EXEC PR_CHECK_STUDENT 2

--6. Handle a Foreign Key Violation while inserting data into Enrollment table and print appropriate error 
--message. 

BEGIN TRY
    INSERT INTO Enrollment(StudentID, CourseID)
    VALUES (999, 101); -- invalid FK
END TRY
BEGIN CATCH
    PRINT 'Foreign Key Error: ' + ERROR_MESSAGE();
END CATCH;

--PART - B

--7. Handle Invalid Date Format 
BEGIN TRY
    DECLARE @d DATE;
    SET @d = CAST('2025-15-40' AS DATE); -- invalid
END TRY
BEGIN CATCH
    PRINT 'Error: Invalid date format.';
END CATCH;
--8. Procedure to Update faculty’s Email with Error Handling. 
GO
CREATE OR ALTER PROC PR_EMAIL_UP
    @EMAIL VARCHAR(50),
    @FID INT
AS
BEGIN
    BEGIN TRY
        UPDATE FACULTY
        SET FacultyEmail = @EMAIL
        WHERE FacultyID = @FID;

        -- Check if any row updated
        IF @@ROWCOUNT = 0
            PRINT 'Error: FacultyID not found.';
        ELSE
            PRINT 'Email updated successfully.';
    END TRY

    BEGIN CATCH
        PRINT 'ERROR: ' + ERROR_MESSAGE();
    END CATCH
END
GO

EXEC PR_EMAIL_UP 'dh123@gmail.com', 101;
--9. Throw custom exception that throws error if the data is invalid. 
   GO
   CREATE OR ALTER PROC PR_CHECK_DATE
   @AGE INT
   AS
   BEGIN
        IF @AGE<0 OR @AGE>120
            THROW 50002,'ERROR: AGE IS INVALID',1;
        ELSE
            PRINT 'VALID'
    END
    GO

EXEC PR_CHECK_DATE 121 
--Msg 50002, Level 16, State 1, Procedure PR_CHECK_DATE, Line 6 [Batch Start Line 131]
--ERROR: AGE IS INVALID

--Part – C 
--10. Write a script that checks if a faculty’s salary is NULL. If it is, use RAISERROR to show a message with a 
--severity of 16. (Note: Do not use any table)
DECLARE @Salary INT = NULL;

IF @Salary IS NULL
BEGIN
    RAISERROR ('Salary cannot be NULL.', 16, 1);
END
ELSE
BEGIN
    PRINT 'Salary is valid.';
END;


