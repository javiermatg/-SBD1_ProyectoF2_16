CREATE OR REPLACE PROCEDURE Registrar_Estudiante(
    p_Carnet IN NUMBER,
    p_Nombres IN VARCHAR2,
    p_Apellidos IN VARCHAR2,
    p_Fecha_Nacimiento IN DATE,
    p_Correo IN VARCHAR2,
    p_Telefono IN NUMBER,
    p_Direccion IN VARCHAR2,
    p_DPI_CUI IN NUMBER,
    p_Carrera IN NUMBER,
    p_Plan IN NUMBER
)
AS
    v_RegexCorreo VARCHAR2(100) := '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
BEGIN
    -- Validar que los nombres y apellidos contengan solo letras
    IF NOT(REGEXP_LIKE(p_Nombres, '^[a-zA-Z ]+$')) THEN
        RAISE_APPLICATION_ERROR(-20001, 'El nombre debe contener solo letras.');
    END IF;
    
    IF NOT(REGEXP_LIKE(p_Apellidos, '^[a-zA-Z ]+$')) THEN
        RAISE_APPLICATION_ERROR(-20002, 'Los apellidos deben contener solo letras.');
    END IF;

    -- Validar el formato del correo
    IF NOT(REGEXP_LIKE(p_Correo, v_RegexCorreo)) THEN
        RAISE_APPLICATION_ERROR(-20003, 'El formato del correo no es válido.');
    END IF;
    
    -- Insertar el estudiante
    INSERT INTO Estudiante (Carnet, Nombre, Apellido, Fecha_Nacimiento, Correo, Telefono, Direccion, DPI, id_carrera, id_plan)
    VALUES (p_Carnet, p_Nombres, p_Apellidos, p_Fecha_Nacimiento, p_Correo, p_Telefono, p_Direccion, p_DPI_CUI, p_Carrera,p_plan);
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END Registrar_Estudiante;
/

EXEC Registrar_Estudiante(202000897,'Javier', 'Matías', '25-04-2001', 'javiermatias246@gmail.com', 51508188, '17ave' , 3681430070101, 09, 08 )

select * from Estudiante;


-- Segundo Procedure
CREATE SEQUENCE carrera_id_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE Crear_Carrera(
    p_Nombre IN VARCHAR2
)
AS
    v_CarreraID NUMBER;
BEGIN
    -- Validar que el nombre contenga solo letras
    IF NOT(REGEXP_LIKE(p_Nombre, '^[a-zA-Z ]+$')) THEN
        RAISE_APPLICATION_ERROR(-20001, 'El nombre de la carrera debe contener solo letras.');
    END IF;

    -- Verificar si la carrera ya existe
    SELECT COUNT(*) INTO v_CarreraID FROM Carrera WHERE Nombre = p_Nombre;
    
    IF v_CarreraID = 0 THEN
        -- Insertar la carrera si no existe
        INSERT INTO Carrera (id, Nombre) VALUES (carrera_id_seq.NEXTVAL, p_Nombre);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Carrera creada exitosamente.');
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'La carrera ya existe');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END Crear_Carrera;
/

-- Test-Funciones
EXEC Crear_Carrera('Derecho');
EXEC Crear_Carrera('Economía');
EXEC Crear_Carrera('Ingeniería');
EXEC Crear_Carrera('Humanidades');
EXEC Crear_Carrera('Humanidadess');

SELECT ID as identificador ,
NOMBRE  FROM carrera;

delete from carrera;
delete from carrera
where nombre = 'Derecho';

drop sequence carrera_id_seq;


-- Tercer Procedure

CREATE OR REPLACE PROCEDURE Agregar_Docente(
    p_Codigo_Empleado IN NUMBER,
    p_Nombres IN VARCHAR2,
    p_Apellidos IN VARCHAR2,
    p_Fecha_Nacimiento IN DATE,
    p_Correo IN VARCHAR2,
    p_Telefono IN NUMBER,
    p_Direccion IN VARCHAR2,
    p_DPI_CUI IN NUMBER,
    p_Salario IN NUMBER
)
AS
    v_RegexCorreo VARCHAR2(100) := '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    v_Existe NUMBER;
BEGIN
    -- Validar que los nombres y apellidos contengan solo letras
    IF NOT(REGEXP_LIKE(p_Nombres, '^[a-zA-Z ]+$')) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Los nombres deben contener solo letras.');
    END IF;
    
    IF NOT(REGEXP_LIKE(p_Apellidos, '^[a-zA-Z ]+$')) THEN
        RAISE_APPLICATION_ERROR(-20002, 'Los apellidos deben contener solo letras.');
    END IF;

    -- Validar el formato del correo
    IF NOT(REGEXP_LIKE(p_Correo, v_RegexCorreo)) THEN
        RAISE_APPLICATION_ERROR(-20003, 'El formato del correo no es válido.');
    END IF;

    -- Validar que el salario sea un número positivo y no mayor a 99,000
    IF p_Salario <= 0 OR p_Salario > 99000 THEN
        RAISE_APPLICATION_ERROR(-20004, 'El salario debe ser un número positivo y no mayor a 99,000.');
    END IF;
    
    -- Verificar si el docente ya existe
    SELECT COUNT(*) INTO v_Existe FROM Docente WHERE Codigo = p_Codigo_Empleado;
    
    IF v_Existe = 0 THEN
        -- Insertar el docente si no existe
        INSERT INTO Docente (Codigo, Nombre, Apellido, Sueldo, Fecha_Nacimiento, Correo, Telefono, Direccion, DPI, Fecha_Registro)
        VALUES (p_Codigo_Empleado, p_Nombres, p_Apellidos, p_Salario, p_Fecha_Nacimiento, p_Correo, p_Telefono, p_Direccion, p_DPI_CUI, SYSDATE);
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Docente agregado exitosamente.');
    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'El docente ya existe');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END Agregar_Docente;
/


EXEC Agregar_Docente(01,'Manuel', 'Jofe', '28-04-2001', 'javiermatia@gmail.com', 36860658, 'zona12', 0707, 5000 );
EXEC Agregar_Docente(01,'Manuel', 'Jofe', '28-04-2001', 'javiermatia@gmail.com', 36860658, 'zona12', 0707, 5000 );

select * from docente;

-- CUARTO PROCEDURE

CREATE OR REPLACE PROCEDURE Registrar_Curso(
    p_Codigo_Curso IN VARCHAR2,
    p_Nombre IN VARCHAR2,
    p_Creditos_Necesarios IN NUMBER,
    p_Creditos_Otorga IN NUMBER,
    p_Obligatorio IN NUMBER,
    p_Plan IN NUMBER
)
AS
    v_Existe NUMBER;
BEGIN
    -- Verificar si el curso ya existe
    SELECT COUNT(*) INTO v_Existe FROM Curso WHERE Codigo = p_Codigo_Curso;
    
    IF v_Existe = 0 THEN
        -- Insertar el curso si no existe
        INSERT INTO Curso (Codigo, Nombre, Creditos_Necesarios, Creditos_Otorga, Obligatorio, c_plan)
        VALUES (p_Codigo_Curso, p_Nombre, p_Creditos_Necesarios, p_Creditos_Otorga, p_Obligatorio, p_Plan);
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Curso registrado exitosamente.');
    ELSE
         RAISE_APPLICATION_ERROR(-20002, 'El curso ya existe');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END Registrar_Curso;
/

EXEC Registrar_Curso('28','IO2', 50, 5, 1, 2 );
select * from curso;

-- QUINTO PROCEDURE
CREATE SEQUENCE prer_id_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE Registrar_Curso_Prerrequisito(
    p_Codigo_Curso IN NUMBER,
    p_Codigo_Prerrequisito IN NUMBER
)
AS
    v_Existe_Curso NUMBER;
    v_Existe_Prerrequisito NUMBER;
BEGIN
    -- Verificar si el curso y el prerrequisito existen
    SELECT COUNT(*) INTO v_Existe_Curso FROM Curso WHERE Codigo = p_Codigo_Curso;
    SELECT COUNT(*) INTO v_Existe_Prerrequisito FROM Curso WHERE Codigo = p_Codigo_Prerrequisito;
    
    IF v_Existe_Curso = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El curso especificado no existe.');
    END IF;
    
    IF v_Existe_Prerrequisito = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'El curso prerrequisito especificado no existe.');
    END IF;
    
    -- Verificar si ya existe la relación
    SELECT COUNT(*) INTO v_Existe_Curso FROM Prerrequisito WHERE curso = p_Codigo_Curso AND curso_prerrequisito = p_Codigo_Prerrequisito;
    
    IF v_Existe_Curso > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'La relación entre el curso y el prerrequisito ya existe.');
    END IF;
    
    -- Insertar la relación si no existe
    INSERT INTO Prerrequisito (id, curso, curso_Prerrequisito)
    VALUES (carrera_id_seq.NEXTVAL,p_Codigo_Curso, p_Codigo_Prerrequisito);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Curso prerrequisito registrado exitosamente.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END Registrar_Curso_Prerrequisito;
/


--SEXTO PROCEDURE

CREATE SEQUENCE id_seccion START WITH 1 INCREMENT BY 1;


CREATE OR REPLACE PROCEDURE Crear_Seccion(
    p_Codigo_Curso IN NUMBER,
    p_Ciclo IN VARCHAR2,
    p_Docente IN NUMBER,
    p_Seccion IN CHAR
)
AS
    v_Año NUMBER;
BEGIN
    -- Obtener el año actual
    SELECT EXTRACT(YEAR FROM SYSDATE) INTO v_Año FROM DUAL;

    -- Validar que el ciclo sea válido
    IF p_Ciclo NOT IN ('1S', '2S', 'VJ', 'VD') THEN
        RAISE_APPLICATION_ERROR(-20001, 'El ciclo debe ser "1S", "2S", "VJ" o "VD".');
    END IF;

    -- Verificar si la sección ya existe para el curso en el ciclo
    IF EXISTS (SELECT 1 FROM Seccion WHERE curso_codigo = p_Codigo_Curso AND Ciclo = p_Ciclo) THEN
        RAISE_APPLICATION_ERROR(-20002, 'La sección ya existe para el curso en el ciclo especificado.');
    END IF;

    -- Insertar la nueva sección
    INSERT INTO Seccion (id, año, ciclo, curso_codigo, docente_codigo, seccion)
    VALUES (id_seccion.NEXTVAL, v_Año, p_Ciclo, p_Codigo_Curso, p_Docente, p_Seccion);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Sección creada exitosamente.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END Crear_Seccion;
/



SELECT table_name
FROM user_tables;

SELECT object_name
FROM user_objects
WHERE object_type = 'PROCEDURE';

SELECT object_name
FROM user_objects
WHERE object_type = 'SEQUENCE';