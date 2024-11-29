-- Tabla: Roles_Usuario
-- Esta tabla almacena los roles que puede tener un usuario dentro del sistema.
CREATE TABLE Roles_Usuario (
    id_rol NUMBER(2) PRIMARY KEY, -- Identificador unico del rol.
    nombre VARCHAR2(50), -- Nombre del rol.
    descripcion VARCHAR2(250) -- Descripcion del rol.
);

-- Tabla: Usuarios
-- Contiene informacion sobre los usuarios registrados en el sistema.
CREATE TABLE Usuarios (
    id_usuario NUMBER PRIMARY KEY, -- Identificador unico del usuario.
    nombre VARCHAR2(100), -- Nombre del usuario.
    primer_apellido VARCHAR2(100), -- Primer apellido del usuario.
    segundo_apellido VARCHAR2(100), -- Segundo apellido del usuario.
    numero_telefono VARCHAR2(15), -- Numero de telefono del usuario.
    email VARCHAR2(200), -- Direccion de correo electronico del usuario.
    foto_perfil_url VARCHAR2(250), -- URL de la foto de perfil del usuario.
    created_at TIMESTAMP, -- Fecha y hora de creacion del registro.
    updated_at TIMESTAMP, -- Fecha y hora de la ultima actualizacion del registro.
    id_rol NUMBER(2), -- Rol asignado al usuario.
    CONSTRAINT fk_usuarios_roles FOREIGN KEY (id_rol) REFERENCES Roles_Usuario(id_rol) -- Llave foranea que relaciona el rol del usuario.
);

CREATE SEQUENCE seq_usuario
START WITH 1
INCREMENT BY 1
NOCACHE;


-- Tabla: Categoria_Transaccion
-- Define las categorias de las transacciones que pueden registrarse en el sistema.
CREATE TABLE Categoria_Transaccion (
    id_categoria_transaccion NUMBER PRIMARY KEY, -- Identificador unico de la categoria de transaccion.
    nombre VARCHAR2(60), -- Nombre de la categoria.
    tipo_categoria VARCHAR2(20), -- Tipo de la categoria (ejemplo: ingreso, gasto).
    categoria_transaccion_id NUMBER, -- Relacion jer�rquica con otra categoria.
    CONSTRAINT fk_categoria_transaccion_padre FOREIGN KEY (categoria_transaccion_id) REFERENCES Categoria_Transaccion(id_categoria_transaccion) -- Llave foranea a la categoria padre.
);

-- Tabla: Recordatorios
-- Registra los recordatorios configurados por los usuarios.
CREATE TABLE Recordatorios (
    id_recordatorio NUMBER PRIMARY KEY, -- Identificador �nico del recordatorio.
    id_event VARCHAR2(10), -- Codigo del evento asociado al recordatorio.
    descripcion_event VARCHAR2(30), -- Descripcion del evento.
    descripcion VARCHAR2(60) -- Descripcion general del recordatorio.
);

-- Tabla: Colecciones
-- Permite agrupar datos en colecciones especificas.
CREATE TABLE Colecciones (
    id_coleccion NUMBER(8) PRIMARY KEY, -- Identificador unico de la coleccion.
    nombre_coleccion VARCHAR2(50), -- Nombre de la coleccion.
    nombre VARCHAR2(30), -- Nombre asociado dentro de la coleccion.
    value VARCHAR2(50) -- Valor almacenado en la coleccion.
);

-- Tabla: Cuentas
-- Almacena informacion sobre las cuentas financieras de los usuarios.
CREATE TABLE Cuentas (
    id_cuenta NUMBER(12) PRIMARY KEY, -- Identificador unico de la cuenta.
    nombre VARCHAR2(70), -- Nombre de la cuenta.
    nombre_entidad_financiera VARCHAR2(8), -- Nombre de la entidad financiera.
    tipo_moneda VARCHAR2(3), -- Tipo de moneda (ejemplo: USD, EUR).
    dinero_monto NUMBER(22, 2), -- Monto disponible en la cuenta.
    created_at TIMESTAMP, -- Fecha y hora de creacion del registro.
    updated_at TIMESTAMP, -- Fecha y hora de la ultima actualizacion del registro.
    id_usuario NUMBER, -- Identificador del usuario dueño de la cuenta.
    CONSTRAINT fk_cuentas_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) -- Llave foranea que relaciona la cuenta con el usuario.
);

-- Tabla: Objetivos
-- Define objetivos financieros que los usuarios desean alcanzar.
CREATE TABLE Objetivos (
    id_objetivo NUMBER PRIMARY KEY, -- Identificador unico del objetivo.
    nombre VARCHAR2(50), -- Nombre del objetivo.
    tipo_objetivo VARCHAR2(20), -- Tipo del objetivo (ejemplo: ahorro, inversion).
    fecha_inicio DATE, -- Fecha de inicio del objetivo.
    fecha_tope DATE, -- Fecha limite para alcanzar el objetivo.
    monto_actual NUMBER(12, 2), -- Monto acumulado hasta el momento.
    monto_meta NUMBER(12, 2), -- Monto meta a alcanzar.
    id_usuario NUMBER, -- Identificador del usuario due�o del objetivo.
    categoria_transaccion_id NUMBER, -- Identificador de la categoria de transaccion asociada.
    CONSTRAINT fk_objetivos_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario), -- Llave foranea que relaciona el objetivo con el usuario.
    CONSTRAINT fk_objetivos_categoria FOREIGN KEY (categoria_transaccion_id) REFERENCES Categoria_Transaccion(id_categoria_transaccion) -- Llave foranea a la categoria de transaccion.
);

-- Tabla: Presupuestos
-- Registra presupuestos financieros asignados por los usuarios.
CREATE TABLE Presupuestos (
    id_presupuesto NUMBER PRIMARY KEY, -- Identificador unico del presupuesto.
    monto_total NUMBER(12,2), -- Monto total del presupuesto.
    is_principal NUMBER(1), -- Indica si el presupuesto es el principal (1: si, 0: no).
    estado NUMBER(1), -- Estado del presupuesto (ejemplo: activo, inactivo).
    created_at TIMESTAMP, -- Fecha y hora de creacion del registro.
    updated_at TIMESTAMP, -- Fecha y hora de la ultima actualizacion del registro.
    id_usuario NUMBER, -- Identificador del usuario dueño del presupuesto.
    CONSTRAINT fk_presupuestos_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) -- Llave foranea que relaciona el presupuesto con el usuario.
);

-- Tabla: Ahorros
-- Almacena registros sobre los ahorros de los usuarios.
CREATE TABLE Ahorros (
    id_ahorro NUMBER(4) PRIMARY KEY, -- Identificador unico del ahorro.
    ahorro_nombre VARCHAR2(50), -- Nombre del ahorro.
    monto NUMBER(18, 2), -- Monto total del ahorro.
    frecuencia VARCHAR2(20), -- Frecuencia de ahorro (ejemplo: mensual, semanal).
    descripcion VARCHAR2(150), -- Descripcion del ahorro.
    fecha_inicio DATE, -- Fecha de inicio del ahorro.
    fecha_final DATE, -- Fecha de finalizacion del ahorro.
    created_at TIMESTAMP, -- Fecha y hora de creacion del registro.
    updated_at TIMESTAMP, -- Fecha y hora de la ultima actualizacion del registro.
    id_usuario NUMBER, -- Identificador del usuario dueño del ahorro.
    id_objetivo NUMBER, -- Identificador del objetivo asociado al ahorro.
    CONSTRAINT fk_ahorros_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario), -- Llave foranea que relaciona el ahorro con el usuario.
    CONSTRAINT fk_ahorros_objetivo FOREIGN KEY (id_objetivo) REFERENCES Objetivos(id_objetivo) -- Llave foranea que relaciona el ahorro con el objetivo.
);

-- Tabla: Pagos
-- Contiene informacion sobre pagos programados por los usuarios.
CREATE TABLE Pagos (
    id_pago NUMBER PRIMARY KEY, -- Identificador unico del pago.
    nombre VARCHAR2(50), -- Nombre del pago.
    monto NUMBER(12, 2), -- Monto del pago.
    frecuencia VARCHAR2(20), -- Frecuencia del pago (ejemplo: mensual, anual).
    fecha_inicio DATE, -- Fecha de inicio del pago.
    fecha_final DATE, -- Fecha de finalizacion del pago.
    created_at TIMESTAMP, -- Fecha y hora de creacion del registro.
    updated_at TIMESTAMP, -- Fecha y hora de la ultima actualizacion del registro.
    id_usuario NUMBER, -- Identificador del usuario que realiza el pago.
    id_categoria_transaccion NUMBER, -- Identificador de la categoria asociada al pago.
    CONSTRAINT fk_pagos_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario), -- Llave foranea que relaciona el pago con el usuario.
    CONSTRAINT fk_pagos_categoria FOREIGN KEY (id_categoria_transaccion) REFERENCES Categoria_Transaccion(id_categoria_transaccion) -- Llave foranea que relaciona el pago con la categoria de transaccion.
);

-- Tabla: Transacciones
-- Registra las transacciones financieras realizadas por los usuarios.
CREATE TABLE Transacciones (
    id_transaccion NUMBER(8) PRIMARY KEY, -- Identificador unico de la transaccion.
    descripcion VARCHAR2(200), -- Descripci�n de la transaccion.
    monto NUMBER(12, 2), -- Monto de la transaccion.
    tipo VARCHAR2(2), -- Tipo de transaccion (ejemplo: ingreso, gasto).
    fecha_movimiento DATE, -- Fecha de la transaccion.
    tipo_moneda VARCHAR2(3), -- Tipo de moneda utilizada en la transaccion.
    created_at TIMESTAMP, -- Fecha y hora de creacion del registro.
    updated_at TIMESTAMP, -- Fecha y hora de la �ltima actualizacion del registro.
    id_usuario NUMBER, -- Identificador del usuario que realiz� la transaccion.
    id_categoria_transaccion NUMBER, -- Identificador de la categoria de transaccion.
    CONSTRAINT fk_transacciones_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario), -- Llave foranea que relaciona la transaccion con el usuario.
    CONSTRAINT fk_transacciones_categoria FOREIGN KEY (id_categoria_transaccion) REFERENCES Categoria_Transaccion(id_categoria_transaccion) -- Llave foranea que relaciona la transaccion con la categoria.
);

-- Tabla: Recordatorios_Usuarios
-- Vincula recordatorios con los usuarios.
CREATE TABLE Recordatorios_Usuarios (
    id_recordatorio NUMBER, -- Identificador del recordatorio.
    id_usuario NUMBER, -- Identificador del usuario.
    CONSTRAINT fk_recordatorios FOREIGN KEY (id_recordatorio) REFERENCES Recordatorios(id_recordatorio), -- Llave foranea que relaciona el recordatorio con su registro en la tabla Recordatorios.
    CONSTRAINT fk_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) -- Llave for�nea que relaciona el recordatorio con el usuario.
);
--------------------------------------------------------------------------------------------------------------PROCEDIMIENTOS CRUD --------------------------------------------------------------------------------------------------------------
--****************************USUARIO***************************************

--Procedimiento: Crear Usuario
-- Este procedimiento permite insertar un nuevo usuario en la tabla "Usuarios"
-- Recibe la c�dula (id_usuario), nombre, apellidos, tel�fono, email, foto de perfil y el rol del usuario
CREATE OR REPLACE PROCEDURE SP_CREAR_USUARIO (
    p_id_usuario IN NUMBER,   -- Par�metro para la cedula (id_usuario)
    p_nombre IN VARCHAR2,     -- Nombre del usuario
    p_primer_apellido IN VARCHAR2,  -- Primer apellido del usuario
    p_segundo_apellido IN VARCHAR2, -- Segundo apellido del usuario
    p_numero_telefono IN VARCHAR2,  -- N�mero de tel�fono del usuario
    p_email IN VARCHAR2,         -- Email del usuario
    p_foto_perfil_url IN VARCHAR2, -- URL de la foto de perfil del usuario
    p_id_rol IN NUMBER           -- Rol del usuario (id_rol)
) AS
BEGIN
    -- Insertar el nuevo usuario en la tabla "Usuarios"
    INSERT INTO Usuarios (
        id_usuario,
        nombre,
        primer_apellido,
        segundo_apellido,
        numero_telefono,
        email,
        foto_perfil_url,
        created_at,
        updated_at,
        id_rol
    )
    VALUES (
        p_id_usuario,             -- La cedula como id_usuario
        p_nombre,                 -- Nombre del usuario
        p_primer_apellido,        -- Primer apellido del usuario
        p_segundo_apellido,       -- Segundo apellido del usuario
        p_numero_telefono,        -- N�mero de tel�fono del usuario
        p_email,                  -- Email del usuario
        p_foto_perfil_url,        -- Foto de perfil del usuario
        SYSDATE,                  -- Fecha de creacion
        SYSDATE,                  -- Fecha de actualizacion
        p_id_rol                  -- Rol del usuario
    );

    COMMIT;  -- Confirmar la transacci�n
END SP_CREAR_USUARIO;

--Procedimiento: Leer Usuarios
-- Este procedimiento permite leer todos los usuarios desde la tabla "Usuarios"
-- Retorna un cursor con los datos de todos los usuarios
CREATE OR REPLACE PROCEDURE sp_leer_usuarios (
    p_usuarios OUT SYS_REFCURSOR  -- Cursor de salida con los usuarios
) AS
BEGIN
    -- Abre un cursor para seleccionar todos los usuarios
    OPEN p_usuarios FOR 
        SELECT * FROM Usuarios;  -- Seleccionar todos los campos de la tabla "Usuarios"
END;
/

--Procedimiento: Actualizar Usuario
-- Este procedimiento permite actualizar los datos de un usuario existente
-- Recibe la c�dula (id_usuario) y los nuevos valores para los campos del usuario
CREATE OR REPLACE PROCEDURE sp_actualizar_usuario (
    p_id_usuario        IN NUMBER,      -- c�dula del usuario a actualizar
    p_nombre            IN VARCHAR2,    -- Nuevo nombre del usuario
    p_primer_apellido   IN VARCHAR2,    -- Nuevo primer apellido
    p_segundo_apellido  IN VARCHAR2,    -- Nuevo segundo apellido
    p_numero_telefono   IN VARCHAR2,    -- Nuevo n�mero de tel�fono
    p_email             IN VARCHAR2,    -- Nuevo email
    p_foto_perfil_url   IN VARCHAR2,    -- Nueva URL de la foto de perfil
    p_id_rol            IN NUMBER       -- Nuevo rol del usuario
) AS
BEGIN
    -- Actualizar los datos del usuario en la tabla "Usuarios"
    UPDATE Usuarios
    SET 
        nombre = p_nombre,                -- Actualizar nombre
        primer_apellido = p_primer_apellido, -- Actualizar primer apellido
        segundo_apellido = p_segundo_apellido, -- Actualizar segundo apellido
        numero_telefono = p_numero_telefono,   -- Actualizar telefono
        email = p_email,                    -- Actualizar email
        foto_perfil_url = p_foto_perfil_url,  -- Actualizar foto de perfil
        updated_at = SYSTIMESTAMP,          -- Fecha de actualizacion
        id_rol = p_id_rol                   -- Actualizar rol
    WHERE id_usuario = p_id_usuario;        -- Buscar el usuario por su cedula
    COMMIT;  -- Confirmar la transaccion
END;
/

--Procedimiento: Eliminar Usuario
-- Este procedimiento permite eliminar un usuario por su cedula (id_usuario)
CREATE OR REPLACE PROCEDURE sp_eliminar_usuario (
    p_id_usuario IN NUMBER  -- cedula del usuario a eliminar
) AS
BEGIN
    -- Eliminar el usuario de la tabla "Usuarios" usando su id_usuario
    DELETE FROM Usuarios WHERE id_usuario = p_id_usuario;
    COMMIT;  -- Confirmar la transaccion
END;
/

--****************************Transacci�n***************************************

-- Crear una secuencia para generar id_transaccion de forma automatica
CREATE SEQUENCE seq_id_transaccion
START WITH 1  -- Iniciar en 1
INCREMENT BY 1  -- Incrementar en 1 por cada nueva transaccion
NOCACHE  -- No almacenar en cache los valores
NOCYCLE;  -- La secuencia no vuelve a empezar al llegar al valor maximo

--Procedimiento: Crear Transacci�n
-- Este procedimiento permite crear una nueva transaccion en la tabla "Transacciones"
-- Recibe la descripci�n, monto, tipo de transacci�n (Ingreso o Gasto), fecha de movimiento, tipo de moneda, id_usuario y id_categoria
CREATE OR REPLACE PROCEDURE sp_crear_transaccion (
    p_descripcion        IN VARCHAR2,    -- Descripcion de la transaccion
    p_monto              IN NUMBER,      -- Monto de la transaccion
    p_tipo               IN VARCHAR2,    -- Tipo de transaccion ('I' para ingreso, 'G' para gasto)
    p_fecha_movimiento   IN DATE,        -- Fecha de la transaccion
    p_tipo_moneda        IN VARCHAR2,    -- Tipo de moneda (ej. USD, EUR)
    p_id_usuario         IN NUMBER,      -- ID del usuario asociado a la transaccion
    p_id_categoria       IN NUMBER       -- ID de la categoria de la transaccion
) AS
BEGIN
    -- Validar que el tipo de transacci�n sea 'I' o 'G'
    IF p_tipo NOT IN ('I', 'G') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Tipo inv�lido. Use "I" para ingreso o "G" para gasto.');
    END IF;

    -- Insertar una nueva transaccion en la tabla "Transacciones"
    INSERT INTO Transacciones (
        id_transaccion, descripcion, monto, tipo, fecha_movimiento, tipo_moneda,
        created_at, updated_at, id_usuario, id_categoria_transaccion
    ) VALUES (
        seq_id_transaccion.NEXTVAL,  -- Generar el ID de la transaccion usando la secuencia
        p_descripcion,               -- Descripcion de la transaccion
        p_monto,                     -- Monto de la transaccion
        p_tipo,                      -- Tipo de transaccion
        p_fecha_movimiento,          -- Fecha del movimiento
        p_tipo_moneda,               -- Tipo de moneda
        SYSTIMESTAMP,                -- Fecha de creacion
        SYSTIMESTAMP,                -- Fecha de actualizacion
        p_id_usuario,                -- ID del usuario que realiza la transaccion
        p_id_categoria               -- ID de la categoria de la transaccion
    );
    COMMIT;  -- Confirmar la transaccion
END;
/

--------------------------------------------------------------------------------------------------------------FUNCIONES DE VALIDACI�N--------------------------------------------------------------------------------------------------------------
--Funci�n: Verificar si un usuario existe
-- Esta funcion retorna TRUE si un usuario con el id especificado existe en la base de datos, de lo contrario retorna FALSE
CREATE OR REPLACE FUNCTION fn_usuario_existe (
    p_id_usuario IN NUMBER  -- cedula del usuario
) RETURN BOOLEAN AS
    v_count NUMBER;  -- Variable para contar los usuarios con el id especificado
BEGIN
    -- Contar cuantos usuarios tienen el id_usuario especificado
    SELECT COUNT(*) INTO v_count
    FROM Usuarios
    WHERE id_usuario = p_id_usuario;

    -- Retornar TRUE si el usuario existe (v_count > 0), de lo contrario FALSE
    RETURN v_count > 0;
END;
/

--------------------------------------------------------------------------------------------------------------CURSORES--------------------------------------------------------------------------------------------------------------

--Procedimiento: Iterar sobre usuarios con un rol espec�fico
-- Este procedimiento abre un cursor para obtener todos los usuarios con el rol especificado y muestra su ID, nombre y email
CREATE OR REPLACE PROCEDURE sp_usuarios_por_rol (
    p_id_rol IN NUMBER  -- Rol de los usuarios a recuperar
) AS
    CURSOR c_usuarios IS  -- Cursor para seleccionar los usuarios con el rol especificado
        SELECT id_usuario, nombre, email
        FROM Usuarios
        WHERE id_rol = p_id_rol;  -- Filtrar por el rol proporcionado
    v_usuario c_usuarios%ROWTYPE;  -- Variable para almacenar los datos de cada usuario
BEGIN
    -- Abrir el cursor
    OPEN c_usuarios;
    LOOP
        -- Obtener los datos de un usuario
        FETCH c_usuarios INTO v_usuario;
        EXIT WHEN c_usuarios%NOTFOUND;  -- Salir del bucle cuando no haya mas usuarios

        -- Mostrar los datos del usuario
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_usuario.id_usuario || 
                             ', Nombre: ' || v_usuario.nombre || 
                             ', Email: ' || v_usuario.email);
    END LOOP;
    -- Cerrar el cursor
    CLOSE c_usuarios;
END;
/
   



-- ===========================
-- VISTA PARA CONSULTAR TRANSACCIONES POR USUARIO
-- ===========================
CREATE OR REPLACE VIEW VistaTransaccionesPorUsuario AS
SELECT
    u.nombre AS NombreUsuario,
    ct.nombre AS Categoria,
    t.monto AS Monto,
    t.fecha_transaccion AS Fecha,
    t.descripcion AS Descripcion
FROM Transacciones t
JOIN Usuarios u ON t.id_usuario = u.id_usuario
JOIN Categoria_Transaccion ct ON t.id_categoria_transaccion = ct.id_categoria_transaccion;

-- ===========================
-- FUNCIONES
-- ===========================

-- Funcion para calcular el saldo de un usuario
CREATE OR REPLACE FUNCTION CalcularSaldoUsuario (
    p_id_usuario IN NUMBER
)
RETURN NUMBER
AS
    v_saldo NUMBER;
BEGIN
    SELECT SUM(CASE WHEN ct.tipo_categoria = 'ingreso' THEN t.monto ELSE -t.monto END)
    INTO v_saldo
    FROM Transacciones t
    JOIN Categoria_Transaccion ct ON t.id_categoria_transaccion = ct.id_categoria_transaccion
    WHERE t.id_usuario = p_id_usuario;

    RETURN NVL(v_saldo, 0);
END;
/

-- ===========================
-- TRIGGER PARA ACTUALIZAR LA FECHA DE MODIFICACION
-- ===========================
CREATE OR REPLACE TRIGGER TriggerActualizarUsuario
BEFORE UPDATE ON Usuarios
FOR EACH ROW
BEGIN
    :NEW.updated_at := SYSDATE;
END;
/

-- ===========================
-- PAQUETES PARA OPERACIONES EN USUARIOS
-- ===========================

CREATE OR REPLACE PACKAGE UsuarioPackage AS
    PROCEDURE AddUsuario (
        p_nombre VARCHAR2,
        p_primer_apellido VARCHAR2,
        p_segundo_apellido VARCHAR2,
        p_numero_telefono VARCHAR2,
        p_email VARCHAR2,
        p_id_rol NUMBER
    );
    FUNCTION ObtenerUsuario (p_id_usuario NUMBER) RETURN VARCHAR2;
END UsuarioPackage;
/
CREATE OR REPLACE PACKAGE BODY UsuarioPackage AS
    PROCEDURE AddUsuario (
        p_nombre VARCHAR2,
        p_primer_apellido VARCHAR2,
        p_segundo_apellido VARCHAR2,
        p_numero_telefono VARCHAR2,
        p_email VARCHAR2,
        p_id_rol NUMBER
    )
    AS
    BEGIN
        INSERT INTO Usuarios (id_usuario, nombre, primer_apellido, segundo_apellido, numero_telefono, email, id_rol, created_at)
        VALUES (seq_usuario.NEXTVAL, p_nombre, p_primer_apellido, p_segundo_apellido, p_numero_telefono, p_email, p_id_rol, SYSDATE);
    END;

    FUNCTION ObtenerUsuario (p_id_usuario NUMBER) RETURN VARCHAR2
    AS
        v_nombre VARCHAR2(200);
    BEGIN
        SELECT nombre || ' ' || primer_apellido || ' ' || segundo_apellido
        INTO v_nombre
        FROM Usuarios
        WHERE id_usuario = p_id_usuario;

        RETURN v_nombre;
    END;
END UsuarioPackage;
/

-- ===========================
-- CURSOR PARA LISTAR USUARIOS
-- ===========================

DECLARE
    CURSOR c_usuarios IS
        SELECT nombre, primer_apellido, email FROM Usuarios;
    v_usuario c_usuarios%ROWTYPE;
BEGIN
    OPEN c_usuarios;
    LOOP
        FETCH c_usuarios INTO v_usuario;
        EXIT WHEN c_usuarios%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_usuario.nombre || ' ' || v_usuario.primer_apellido || ': ' || v_usuario.email);
    END LOOP;
    CLOSE c_usuarios;
END;
/



-- ===========================
-- PROCEDIMIENTOS ADICIONALES
-- ===========================

-- Procedimiento para agregar una categoria de transaccion
CREATE OR REPLACE PROCEDURE AddCategoriaTransaccion (
    p_nombre VARCHAR2,
    p_tipo_categoria VARCHAR2
)
AS
BEGIN
    INSERT INTO Categoria_Transaccion (id_categoria_transaccion, nombre, tipo_categoria)
    VALUES (seq_categoria_transaccion.NEXTVAL, p_nombre, p_tipo_categoria);
END;
/

-- Procedimiento para agregar una transaccion
CREATE OR REPLACE PROCEDURE AddTransaccion (
    p_id_usuario NUMBER,
    p_id_categoria NUMBER,
    p_monto NUMBER,
    p_fecha DATE,
    p_descripcion VARCHAR2
)
AS
BEGIN
    INSERT INTO Transacciones (id_usuario, id_categoria_transaccion, monto, fecha_transaccion, descripcion)
    VALUES (p_id_usuario, p_id_categoria, p_monto, p_fecha, p_descripcion);
END;
/

-- Procedimiento para obtener todas las transacciones de un usuario
CREATE OR REPLACE PROCEDURE GetTransaccionesByUsuario (
    p_id_usuario IN NUMBER
)
AS
    CURSOR trans_cursor IS
        SELECT t.id_transaccion, t.monto, t.fecha_transaccion, ct.nombre AS categoria
        FROM Transacciones t
        JOIN Categoria_Transaccion ct ON t.id_categoria_transaccion = ct.id_categoria_transaccion
        WHERE t.id_usuario = p_id_usuario;
    v_trans trans_cursor%ROWTYPE;
BEGIN
    OPEN trans_cursor;
    LOOP
        FETCH trans_cursor INTO v_trans;
        EXIT WHEN trans_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_trans.id_transaccion || ', Monto: ' || v_trans.monto || ', Fecha: ' || v_trans.fecha_transaccion || ', Categor�a: ' || v_trans.categoria);
    END LOOP;
    CLOSE trans_cursor;
END;
/

-- ===========================
-- FUNCIONES ADICIONALES
-- ===========================

-- Funci�n para calcular el total de ingresos de un usuario
CREATE OR REPLACE FUNCTION TotalIngresosUsuario (
    p_id_usuario IN NUMBER
)
RETURN NUMBER
AS
    v_total NUMBER;
BEGIN
    SELECT SUM(monto)
    INTO v_total
    FROM Transacciones t
    JOIN Categoria_Transaccion ct ON t.id_categoria_transaccion = ct.id_categoria_transaccion
    WHERE t.id_usuario = p_id_usuario AND ct.tipo_categoria = 'ingreso';

    RETURN NVL(v_total, 0);
END;
/

-- Funci�n para calcular el total de gastos de un usuario
CREATE OR REPLACE FUNCTION TotalGastosUsuario (
    p_id_usuario IN NUMBER
)
RETURN NUMBER
AS
    v_total NUMBER;
BEGIN
    SELECT SUM(monto)
    INTO v_total
    FROM Transacciones t
    JOIN Categoria_Transaccion ct ON t.id_categoria_transaccion = ct.id_categoria_transaccion
    WHERE t.id_usuario = p_id_usuario AND ct.tipo_categoria = 'gasto';

    RETURN NVL(v_total, 0);
END;
/

-- ===========================
-- VISTAS ADICIONALES
-- ===========================

-- Vista para mostrar los ingresos por usuario
CREATE OR REPLACE VIEW VistaIngresos AS
SELECT
    u.nombre AS NombreUsuario,
    SUM(t.monto) AS TotalIngresos
FROM Transacciones t
JOIN Usuarios u ON t.id_usuario = u.id_usuario
JOIN Categoria_Transaccion ct ON t.id_categoria_transaccion = ct.id_categoria_transaccion
WHERE ct.tipo_categoria = 'ingreso'
GROUP BY u.nombre;

-- Vista para mostrar los gastos por usuario
CREATE OR REPLACE VIEW VistaGastos AS
SELECT
    u.nombre AS NombreUsuario,
    SUM(t.monto) AS TotalGastos
FROM Transacciones t
JOIN Usuarios u ON t.id_usuario = u.id_usuario
JOIN Categoria_Transaccion ct ON t.id_categoria_transaccion = ct.id_categoria_transaccion
WHERE ct.tipo_categoria = 'gasto'
GROUP BY u.nombre;

-- ===========================
-- TRIGGERS ADICIONALES
-- ===========================

-- Trigger para evitar montos negativos en transacciones
CREATE OR REPLACE TRIGGER TriggerValidarMontoTransaccion
BEFORE INSERT OR UPDATE ON Transacciones
FOR EACH ROW
BEGIN
    IF :NEW.monto < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El monto no puede ser negativo.');
    END IF;
END;
/

-- Trigger para registrar un log cuando se elimina una transacci�n
CREATE OR REPLACE TRIGGER TriggerLogEliminarTransaccion
AFTER DELETE ON Transacciones
FOR EACH ROW
BEGIN
    INSERT INTO Log_Transacciones (id_transaccion, accion, fecha_accion)
    VALUES (:OLD.id_transaccion, 'ELIMINADA', SYSDATE);
END;
/

-- ===========================
-- PAQUETES ADICIONALES
-- ===========================

-- Paquete para manejar las categor�as de transacciones
CREATE OR REPLACE PACKAGE CategoriaTransaccionPackage AS
    PROCEDURE AddCategoria (p_nombre VARCHAR2, p_tipo_categoria VARCHAR2);
    PROCEDURE ListarCategorias;
END CategoriaTransaccionPackage;
/
CREATE OR REPLACE PACKAGE BODY CategoriaTransaccionPackage AS
    PROCEDURE AddCategoria (p_nombre VARCHAR2, p_tipo_categoria VARCHAR2)
    AS
    BEGIN
        INSERT INTO Categoria_Transaccion (id_categoria_transaccion, nombre, tipo_categoria)
        VALUES (seq_categoria_transaccion.NEXTVAL, p_nombre, p_tipo_categoria);
    END;

    PROCEDURE ListarCategorias
    AS
        CURSOR cat_cursor IS
            SELECT nombre, tipo_categoria FROM Categoria_Transaccion;
        v_categoria cat_cursor%ROWTYPE;
    BEGIN
        OPEN cat_cursor;
        LOOP
            FETCH cat_cursor INTO v_categoria;
            EXIT WHEN cat_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Categor�a: ' || v_categoria.nombre || ', Tipo: ' || v_categoria.tipo_categoria);
        END LOOP;
        CLOSE cat_cursor;
    END;
END CategoriaTransaccionPackage;
/


