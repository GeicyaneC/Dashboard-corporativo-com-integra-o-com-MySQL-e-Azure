-- Criar o schema se não existir
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'azure_company')
BEGIN
    EXEC('CREATE SCHEMA azure_company');
END

-- Remover tabelas se existirem
IF OBJECT_ID('azure_company.works_on', 'U') IS NOT NULL
    DROP TABLE azure_company.works_on;

IF OBJECT_ID('azure_company.dependent', 'U') IS NOT NULL
    DROP TABLE azure_company.dependent;

IF OBJECT_ID('azure_company.project', 'U') IS NOT NULL
    DROP TABLE azure_company.project;

IF OBJECT_ID('azure_company.dept_locations', 'U') IS NOT NULL
    DROP TABLE azure_company.dept_locations;

IF OBJECT_ID('azure_company.departament', 'U') IS NOT NULL
    DROP TABLE azure_company.departament;

IF OBJECT_ID('azure_company.employee', 'U') IS NOT NULL
    DROP TABLE azure_company.employee;

-- Criar a tabela employee
CREATE TABLE azure_company.employee (
    Fname VARCHAR(15) NOT NULL,
    Minit CHAR,
    Lname VARCHAR(15) NOT NULL,
    Ssn CHAR(9) NOT NULL PRIMARY KEY,
    Bdate DATE,
    Address VARCHAR(30),
    Sex CHAR,
    Salary DECIMAL(10, 2) CHECK (Salary > 2000.0),
    Super_ssn CHAR(9),
    Dno INT NOT NULL DEFAULT 1
);

-- Adicionar chave estrangeira na tabela employee sem ações em cascata
ALTER TABLE azure_company.employee 
ADD CONSTRAINT fk_employee 
FOREIGN KEY (Super_ssn) REFERENCES azure_company.employee(Ssn)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

-- Criar a tabela departament
CREATE TABLE azure_company.departament (
    Dname VARCHAR(15) NOT NULL,
    Dnumber INT NOT NULL PRIMARY KEY,
    Mgr_ssn CHAR(9) NOT NULL,
    Mgr_start_date DATE,
    Dept_create_date DATE,
    CHECK (Dept_create_date < Mgr_start_date),
    UNIQUE (Dname),
    FOREIGN KEY (Mgr_ssn) REFERENCES azure_company.employee(Ssn)
);

-- Criar a tabela dept_locations
CREATE TABLE azure_company.dept_locations (
    Dnumber INT NOT NULL,
    Dlocation VARCHAR(15) NOT NULL,
    PRIMARY KEY (Dnumber, Dlocation),
    FOREIGN KEY (Dnumber) REFERENCES azure_company.departament(Dnumber)
);

-- Criar a tabela project
CREATE TABLE azure_company.project (
    Pname VARCHAR(15) NOT NULL,
    Pnumber INT NOT NULL PRIMARY KEY,
    Plocation VARCHAR(15),
    Dnum INT NOT NULL,
    UNIQUE (Pname),
    FOREIGN KEY (Dnum) REFERENCES azure_company.departament(Dnumber)
);

-- Criar a tabela works_on
CREATE TABLE azure_company.works_on (
    Essn CHAR(9) NOT NULL,
    Pno INT NOT NULL,
    Hours DECIMAL(3, 1) NOT NULL,
    PRIMARY KEY (Essn, Pno),
    FOREIGN KEY (Essn) REFERENCES azure_company.employee(Ssn),
    FOREIGN KEY (Pno) REFERENCES azure_company.project(Pnumber)
);

-- Criar a tabela dependent
CREATE TABLE azure_company.dependent (
    Essn CHAR(9) NOT NULL,
    Dependent_name VARCHAR(15) NOT NULL,
    Sex CHAR,
    Bdate DATE,
    Relationship VARCHAR(8),
    PRIMARY KEY (Essn, Dependent_name),
    FOREIGN KEY (Essn) REFERENCES azure_company.employee(Ssn)
);

-- Inserir dados na tabela employee
INSERT INTO azure_company.employee (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES 
('John', 'B', 'Smith', '123456789', '1965-01-09', '731-Fondren-Houston-TX', 'M', 30000, '333445555', 5),
('Franklin', 'T', 'Wong', '333445555', '1955-12-08', '638-Voss-Houston-TX', 'M', 40000, '888665555', 5),
('Alicia', 'J', 'Zelaya', '999887777', '1968-01-19', '3321-Castle-Spring-TX', 'F', 25000, '987654321', 4),
('Jennifer', 'S', 'Wallace', '987654321', '1941-06-20', '291-Berry-Bellaire-TX', 'F', 43000, '888665555', 4),
('Ramesh', 'K', 'Narayan', '666884444', '1962-09-15', '975-Fire-Oak-Humble-TX', 'M', 38000, '333445555', 5),
('Joyce', 'A', 'English', '453453453', '1972-07-31', '5631-Rice-Houston-TX', 'F', 25000, '333445555', 5),
('Ahmad', 'V', 'Jabbar', '987987987', '1969-03-29', '980-Dallas-Houston-TX', 'M', 25000, '987654321', 4),
('James', 'E', 'Borg', '888665555', '1937-11-10', '450-Stone-Houston-TX', 'M', 55000, NULL, 1);

-- Inserir dados na tabela dependent
INSERT INTO azure_company.dependent (Essn, Dependent_name, Sex, Bdate, Relationship) VALUES 
('333445555', 'Alice', 'F', '1986-04-05', 'Daughter'),
('333445555', 'Theodore', 'M', '1983-10-25', 'Son'),
('333445555', 'Joy', 'F', '1958-05-03', 'Spouse'),
('987654321', 'Abner', 'M', '1942-02-28', 'Spouse'),
('123456789', 'Michael', 'M', '1988-01-04', 'Son'),
('123456789', 'Alice', 'F', '1988-12-30', 'Daughter'),
('123456789', 'Elizabeth', 'F', '1967-05-05', 'Spouse');

-- Inserir dados na tabela departament
INSERT INTO azure_company.departament (Dname, Dnumber, Mgr_ssn, Mgr_start_date, Dept_create_date) VALUES 
('Research', 5, '333445555', '1988-05-22', '1986-05-22'),
('Administration', 4, '987654321', '1995-01-01', '1994-01-01'),
('Headquarters', 1, '888665555', '1981-06-19', '1980-06-19');

-- Inserir dados na tabela dept_locations
INSERT INTO azure_company.dept_locations (Dnumber, Dlocation) VALUES 
(1, 'Houston'),
(4, 'Stafford'),
(5, 'Bellaire'),
(5, 'Sugarland'),
(5, 'Houston');

-- Inserir dados na tabela project
INSERT INTO azure_company.project (Pname, Pnumber, Plocation, Dnum) VALUES 
('ProductX', 1, 'Bellaire', 5),
('ProductY', 2, 'Sugarland', 5),
('ProductZ', 3, 'Houston', 5),
('Computerization', 10, 'Stafford', 4),
('Reorganization', 20, 'Houston', 1),
('Newbenefits', 30, 'Stafford', 4);

-- Inserir dados na tabela works_on
INSERT INTO azure_company.works_on (Essn, Pno, Hours) VALUES 
('123456789', 1, 32.5),
('123456789', 2, 7.5),
('666884444', 3, 40.0),
('453453453', 1, 20.0),
('453453453', 2, 20.0),
('333445555', 2, 10.0),
('333445555', 3, 10.0),
('333445555', 10, 10.0),
('333445555', 20, 10.0),
('999887777', 30, 30.0),
('999887777', 10, 10.0),
('987987987', 10, 35.0),
('987987987', 30, 5.0),
('987654321', 30, 20.0),
('987654321', 20, 15.0),
('888665555', 20, 0.0);

-- Consultas SQL
SELECT * FROM azure_company.employee;

SELECT e.Ssn, COUNT(d.Essn) 
FROM azure_company.employee e 
JOIN azure_company.dependent d ON e.Ssn = d.Essn 
GROUP BY e.Ssn;

SELECT * FROM azure_company.dependent;

-- Consultar projetos localizados em Stafford
SELECT p.Pnumber, p.Dnum, d.Dname, l.Dlocation, e.Bdate
FROM azure_company.project p
JOIN azure_company.departament d ON p.Dnum = d.Dnumber
JOIN azure_company.employee e ON e.Dno = d.Dnumber
JOIN azure_company.dept_locations l ON d.Dnumber = l.Dnumber
WHERE l.Dlocation = 'Stafford';
