-- Generado por Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   en:        2024-04-28 21:33:23 CST
--   sitio:      Oracle Database 21c
--   tipo:      Oracle Database 21c



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE asignacion (
    id                     INTEGER NOT NULL,
    zona                   FLOAT(4) NOT NULL,
    nota                   INTEGER NOT NULL,
    seccion_id             INTEGER NOT NULL,
    seccion_docente_codigo INTEGER NOT NULL,
    seccion_codigo1        INTEGER NOT NULL,
    estudiante_carnet      INTEGER NOT NULL
);

ALTER TABLE asignacion
    ADD CONSTRAINT asignacion_pk PRIMARY KEY ( id,
                                               seccion_id,
                                               seccion_docente_codigo,
                                               seccion_codigo1,
                                               estudiante_carnet );

CREATE TABLE carrera (
    id     INTEGER NOT NULL,
    nombre VARCHAR2(240) NOT NULL
);

ALTER TABLE carrera ADD CONSTRAINT carrera_pk PRIMARY KEY ( id );

CREATE TABLE curso (
    codigo              INTEGER NOT NULL,
    nombre              VARCHAR2(240) NOT NULL,
    creditos_necesarios INTEGER NOT NULL,
    creditos_otorga     INTEGER NOT NULL,
    obligatorio         INTEGER NOT NULL,
    plan                INTEGER NOT NULL
);

ALTER TABLE curso ADD CONSTRAINT curso_pk PRIMARY KEY ( codigo );

CREATE TABLE dia (
    id     INTEGER NOT NULL,
    nombre VARCHAR2 
--  ERROR: VARCHAR2 size not specified 
     NOT NULL
);

ALTER TABLE dia ADD CONSTRAINT dia_pk PRIMARY KEY ( id );

CREATE TABLE docente (
    codigo           INTEGER NOT NULL,
    nombre           VARCHAR2(240) NOT NULL,
    apellido         VARCHAR2(240) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    correo           VARCHAR2(240),
    telefono         INTEGER,
    direccion        VARCHAR2(240),
    dpi              INTEGER NOT NULL,
    sueldo           FLOAT(7) NOT NULL
);

ALTER TABLE docente ADD CONSTRAINT docente_pk PRIMARY KEY ( codigo );

CREATE TABLE estudiante (
    carnet           INTEGER NOT NULL,
    nombre           VARCHAR2(240) NOT NULL,
    apellido         VARCHAR2 
--  ERROR: VARCHAR2 size not specified 
     NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    correo           VARCHAR2(240),
    telefono         INTEGER,
    direccion        VARCHAR2(240),
    dpi              INTEGER NOT NULL,
    carrera          INTEGER NOT NULL,
    plan             INTEGER NOT NULL
);

ALTER TABLE estudiante ADD CONSTRAINT estudiante_pk PRIMARY KEY ( carnet );

CREATE TABLE horario (
    id              INTEGER NOT NULL,
    dia             INTEGER NOT NULL,
    periodo_id      INTEGER NOT NULL,
    dia_id          INTEGER NOT NULL,
    seccion_id      INTEGER NOT NULL,
    seccion_codigo  INTEGER NOT NULL,
    seccion_codigo1 INTEGER NOT NULL,
    salon_id        INTEGER NOT NULL
);

CREATE UNIQUE INDEX horario__idx ON
    horario (
        salon_id
    ASC );

ALTER TABLE horario
    ADD CONSTRAINT horario_pk PRIMARY KEY ( id,
                                            dia_id,
                                            seccion_id,
                                            seccion_codigo,
                                            seccion_codigo1 );

CREATE TABLE inscrito (
    id                INTEGER NOT NULL,
    fecha_inscripcion DATE NOT NULL,
    carrera_id        INTEGER NOT NULL,
    estudiante_carnet INTEGER NOT NULL
);

ALTER TABLE inscrito
    ADD CONSTRAINT inscrito_pk PRIMARY KEY ( id,
                                             carrera_id,
                                             estudiante_carnet );

CREATE TABLE pensum (
    codigo          INTEGER NOT NULL,
    obligatoriedad  VARCHAR2(1) NOT NULL,
    num_creditos    INTEGER NOT NULL,
    nota_aprobacion INTEGER NOT NULL,
    zona_minima     INTEGER NOT NULL,
    cred_prerreq    INTEGER NOT NULL,
    curso_codigo    INTEGER NOT NULL,
    plan_id         INTEGER NOT NULL,
    plan_id1        INTEGER NOT NULL
);

ALTER TABLE pensum
    ADD CONSTRAINT pensum_pk PRIMARY KEY ( codigo,
                                           curso_codigo,
                                           plan_id,
                                           plan_id1 );

CREATE TABLE periodo (
    id          INTEGER NOT NULL,
    hora_inicio DATE NOT NULL,
    hora_fin    DATE NOT NULL
);

ALTER TABLE periodo ADD CONSTRAINT periodo_pk PRIMARY KEY ( id );

CREATE TABLE plan (
    id                  INTEGER NOT NULL,
    nombre              VARCHAR2(240) NOT NULL,
    anio_inicio         VARCHAR2(4) NOT NULL,
    ciclo_inicial       VARCHAR2(50) NOT NULL,
    anio_final          VARCHAR2(4) NOT NULL,
    ciclo_final         VARCHAR2(50) NOT NULL,
    num_creditos_cierre INTEGER NOT NULL,
    carrera_id          INTEGER NOT NULL
);

ALTER TABLE plan ADD CONSTRAINT plan_pk PRIMARY KEY ( id,
                                                      carrera_id );

CREATE TABLE prerrequisito (
    id                  INTEGER NOT NULL,
    curso_prerrequisito INTEGER NOT NULL,
    curso_codigo        INTEGER NOT NULL,
    pensum_codigo       INTEGER NOT NULL,
    pensum_curso_codigo INTEGER NOT NULL,
    pensum_plan_id      INTEGER NOT NULL,
    pensum_plan_id1     INTEGER NOT NULL
);

ALTER TABLE prerrequisito
    ADD CONSTRAINT prerrequisito_pk PRIMARY KEY ( id,
                                                  curso_codigo,
                                                  pensum_codigo,
                                                  pensum_curso_codigo,
                                                  pensum_plan_id,
                                                  pensum_plan_id1 );

CREATE TABLE salon (
    id        INTEGER NOT NULL,
    capacidad INTEGER NOT NULL,
    edidficio VARCHAR2(240) NOT NULL
);

ALTER TABLE salon ADD CONSTRAINT salon_pk PRIMARY KEY ( id );

CREATE TABLE seccion (
    id             INTEGER NOT NULL,
    año            INTEGER NOT NULL,
    ciclo          VARCHAR2(2) NOT NULL,
    seccion        VARCHAR2(1) NOT NULL,
    docente_codigo INTEGER NOT NULL,
    curso_codigo   INTEGER NOT NULL
);

ALTER TABLE seccion
    ADD CONSTRAINT seccion_pk PRIMARY KEY ( id,
                                            docente_codigo,
                                            curso_codigo );

ALTER TABLE asignacion
    ADD CONSTRAINT asignacion_estudiante_fk FOREIGN KEY ( estudiante_carnet )
        REFERENCES estudiante ( carnet );

ALTER TABLE asignacion
    ADD CONSTRAINT asignacion_seccion_fk FOREIGN KEY ( seccion_id,
                                                       seccion_docente_codigo,
                                                       seccion_codigo1 )
        REFERENCES seccion ( id,
                             docente_codigo,
                             curso_codigo );

ALTER TABLE horario
    ADD CONSTRAINT horario_dia_fk FOREIGN KEY ( dia_id )
        REFERENCES dia ( id );

ALTER TABLE horario
    ADD CONSTRAINT horario_periodo_fk FOREIGN KEY ( periodo_id )
        REFERENCES periodo ( id );

ALTER TABLE horario
    ADD CONSTRAINT horario_salon_fk FOREIGN KEY ( salon_id )
        REFERENCES salon ( id );

ALTER TABLE horario
    ADD CONSTRAINT horario_seccion_fk FOREIGN KEY ( seccion_id,
                                                    seccion_codigo,
                                                    seccion_codigo1 )
        REFERENCES seccion ( id,
                             docente_codigo,
                             curso_codigo );

ALTER TABLE inscrito
    ADD CONSTRAINT inscrito_carrera_fk FOREIGN KEY ( carrera_id )
        REFERENCES carrera ( id );

ALTER TABLE inscrito
    ADD CONSTRAINT inscrito_estudiante_fk FOREIGN KEY ( estudiante_carnet )
        REFERENCES estudiante ( carnet );

ALTER TABLE pensum
    ADD CONSTRAINT pensum_curso_fk FOREIGN KEY ( curso_codigo )
        REFERENCES curso ( codigo );

ALTER TABLE pensum
    ADD CONSTRAINT pensum_plan_fk FOREIGN KEY ( plan_id,
                                                plan_id1 )
        REFERENCES plan ( id,
                          carrera_id );

ALTER TABLE plan
    ADD CONSTRAINT plan_carrera_fk FOREIGN KEY ( carrera_id )
        REFERENCES carrera ( id );

ALTER TABLE prerrequisito
    ADD CONSTRAINT prerrequisito_curso_fk FOREIGN KEY ( curso_codigo )
        REFERENCES curso ( codigo );

ALTER TABLE prerrequisito
    ADD CONSTRAINT prerrequisito_pensum_fk FOREIGN KEY ( pensum_codigo,
                                                         pensum_curso_codigo,
                                                         pensum_plan_id,
                                                         pensum_plan_id1 )
        REFERENCES pensum ( codigo,
                            curso_codigo,
                            plan_id,
                            plan_id1 );

ALTER TABLE seccion
    ADD CONSTRAINT seccion_curso_fk FOREIGN KEY ( curso_codigo )
        REFERENCES curso ( codigo );

ALTER TABLE seccion
    ADD CONSTRAINT seccion_docente_fk FOREIGN KEY ( docente_codigo )
        REFERENCES docente ( codigo );



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            14
-- CREATE INDEX                             1
-- ALTER TABLE                             29
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   2
-- WARNINGS                                 0
