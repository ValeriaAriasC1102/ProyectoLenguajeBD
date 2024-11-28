-- Tabla: Roles_Usuario
-- Esta tabla almacena los roles que puede tener un usuario dentro del sistema.
CREATE TABLE Roles_Usuario (
    id_rol NUMBER(2) PRIMARY KEY, -- Identificador �nico del rol.
    nombre VARCHAR2(50), -- Nombre del rol.
    descripcion VARCHAR2(250) -- Descripci�n del rol.
);

-- Tabla: Usuarios
-- Contiene informaci�n sobre los usuarios registrados en el sistema.
CREATE TABLE Usuarios (
    id_usuario NUMBER PRIMARY KEY, -- Identificador �nico del usuario.
    nombre VARCHAR2(100), -- Nombre del usuario.
    primer_apellido VARCHAR2(100), -- Primer apellido del usuario.
    segundo_apellido VARCHAR2(100), -- Segundo apellido del usuario.
    numero_telefono VARCHAR2(15), -- N�mero de tel�fono del usuario.
    email VARCHAR2(200), -- Direcci�n de correo electr�nico del usuario.
    foto_perfil_url VARCHAR2(250), -- URL de la foto de perfil del usuario.
    created_at TIMESTAMP, -- Fecha y hora de creaci�n del registro.
    updated_at TIMESTAMP, -- Fecha y hora de la �ltima actualizaci�n del registro.
    id_rol NUMBER(2), -- Rol asignado al usuario.
    CONSTRAINT fk_usuarios_roles FOREIGN KEY (id_rol) REFERENCES Roles_Usuario(id_rol) -- Llave for�nea que relaciona el rol del usuario.
);

CREATE SEQUENCE seq_usuario
START WITH 1
INCREMENT BY 1
NOCACHE;


-- Tabla: Categoria_Transaccion
-- Define las categor�as de las transacciones que pueden registrarse en el sistema.
CREATE TABLE Categoria_Transaccion (
    id_categoria_transaccion NUMBER PRIMARY KEY, -- Identificador �nico de la categor�a de transacci�n.
    nombre VARCHAR2(60), -- Nombre de la categor�a.
    tipo_categoria VARCHAR2(20), -- Tipo de la categor�a (ejemplo: ingreso, gasto).
    categoria_transaccion_id NUMBER, -- Relaci�n jer�rquica con otra categor�a.
    CONSTRAINT fk_categoria_transaccion_padre FOREIGN KEY (categoria_transaccion_id) REFERENCES Categoria_Transaccion(id_categoria_transaccion) -- Llave for�nea a la categor�a padre.
);

-- Tabla: Recordatorios
-- Registra los recordatorios configurados por los usuarios.
CREATE TABLE Recordatorios (
    id_recordatorio NUMBER PRIMARY KEY, -- Identificador �nico del recordatorio.
    id_event VARCHAR2(10), -- C�digo del evento asociado al recordatorio.
    descripcion_event VARCHAR2(30), -- Descripci�n del evento.
    descripcion VARCHAR2(60) -- Descripci�n general del recordatorio.
);

-- Tabla: Colecciones
-- Permite agrupar datos en colecciones espec�ficas.
CREATE TABLE Colecciones (
    id_coleccion NUMBER(8) PRIMARY KEY, -- Identificador �nico de la colecci�n.
    nombre_coleccion VARCHAR2(50), -- Nombre de la colecci�n.
    nombre VARCHAR2(30), -- Nombre asociado dentro de la colecci�n.
    value VARCHAR2(50) -- Valor almacenado en la colecci�n.
);

-- Tabla: Cuentas
-- Almacena informaci�n sobre las cuentas financieras de los usuarios.
CREATE TABLE Cuentas (
    id_cuenta NUMBER(12) PRIMARY KEY, -- Identificador �nico de la cuenta.
    nombre VARCHAR2(70), -- Nombre de la cuenta.
    nombre_entidad_financiera VARCHAR2(8), -- Nombre de la entidad financiera.
    tipo_moneda VARCHAR2(3), -- Tipo de moneda (ejemplo: USD, EUR).
    dinero_monto NUMBER(22, 2), -- Monto disponible en la cuenta.
    created_at TIMESTAMP, -- Fecha y hora de creaci�n del registro.
    updated_at TIMESTAMP, -- Fecha y hora de la �ltima actualizaci�n del registro.
    id_usuario NUMBER, -- Identificador del usuario due�o de la cuenta.
    CONSTRAINT fk_cuentas_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) -- Llave for�nea que relaciona la cuenta con el usuario.
);

-- Tabla: Objetivos
-- Define objetivos financieros que los usuarios desean alcanzar.
CREATE TABLE Objetivos (
    id_objetivo NUMBER PRIMARY KEY, -- Identificador �nico del objetivo.
    nombre VARCHAR2(50), -- Nombre del objetivo.
    tipo_objetivo VARCHAR2(20), -- Tipo del objetivo (ejemplo: ahorro, inversi�n).
    fecha_inicio DATE, -- Fecha de inicio del objetivo.
    fecha_tope DATE, -- Fecha l�mite para alcanzar el objetivo.
    monto_actual NUMBER(12, 2), -- Monto acumulado hasta el momento.
    monto_meta NUMBER(12, 2), -- Monto meta a alcanzar.
    id_usuario NUMBER, -- Identificador del usuario due�o del objetivo.
    categoria_transaccion_id NUMBER, -- Identificador de la categor�a de transacci�n asociada.
    CONSTRAINT fk_objetivos_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario), -- Llave for�nea que relaciona el objetivo con el usuario.
    CONSTRAINT fk_objetivos_categoria FOREIGN KEY (categoria_transaccion_id) REFERENCES Categoria_Transaccion(id_categoria_transaccion) -- Llave for�nea a la categor�a de transacci�n.
);

-- Tabla: Presupuestos
-- Registra presupuestos financieros asignados por los usuarios.
CREATE TABLE Presupuestos (
    id_presupuesto NUMBER PRIMARY KEY, -- Identificador �nico del presupuesto.
    monto_total NUMBER(12,2), -- Monto total del presupuesto.
    is_principal NUMBER(1), -- Indica si el presupuesto es el principal (1: s�, 0: no).
    estado NUMBER(1), -- Estado del presupuesto (ejemplo: activo, inactivo).
    created_at TIMESTAMP, -- Fecha y hora de creaci�n del registro.
    updated_at TIMESTAMP, -- Fecha y hora de la �ltima actualizaci�n del registro.
    id_usuario NUMBER, -- Identificador del usuario due�o del presupuesto.
    CONSTRAINT fk_presupuestos_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) -- Llave for�nea que relaciona el presupuesto con el usuario.
);

-- Tabla: Ahorros
-- Almacena registros sobre los ahorros de los usuarios.
CREATE TABLE Ahorros (
    id_ahorro NUMBER(4) PRIMARY KEY, -- Identificador �nico del ahorro.
    ahorro_nombre VARCHAR2(50), -- Nombre del ahorro.
    monto NUMBER(18, 2), -- Monto total del ahorro.
    frecuencia VARCHAR2(20), -- Frecuencia de ahorro (ejemplo: mensual, semanal).
    descripcion VARCHAR2(150), -- Descripci�n del ahorro.
    fecha_inicio DATE, -- Fecha de inicio del ahorro.
    fecha_final DATE, -- Fecha de finalizaci�n del ahorro.
    created_at TIMESTAMP, -- Fecha y hora de creaci�n del registro.
    updated_at TIMESTAMP, -- Fecha y hora de la �ltima actualizaci�n del registro.
    id_usuario NUMBER, -- Identificador del usuario due�o del ahorro.
    id_objetivo NUMBER, -- Identificador del objetivo asociado al ahorro.
    CONSTRAINT fk_ahorros_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario), -- Llave for�nea que relaciona el ahorro con el usuario.
    CONSTRAINT fk_ahorros_objetivo FOREIGN KEY (id_objetivo) REFERENCES Objetivos(id_objetivo) -- Llave for�nea que relaciona el ahorro con el objetivo.
);

-- Tabla: Pagos
-- Contiene informaci�n sobre pagos programados por los usuarios.
CREATE TABLE Pagos (
    id_pago NUMBER PRIMARY KEY, -- Identificador �nico del pago.
    nombre VARCHAR2(50), -- Nombre del pago.
    monto NUMBER(12, 2), -- Monto del pago.
    frecuencia VARCHAR2(20), -- Frecuencia del pago (ejemplo: mensual, anual).
    fecha_inicio DATE, -- Fecha de inicio del pago.
    fecha_final DATE, -- Fecha de finalizaci�n del pago.
    created_at TIMESTAMP, -- Fecha y hora de creaci�n del registro.
    updated_at TIMESTAMP, -- Fecha y hora de la �ltima actualizaci�n del registro.
    id_usuario NUMBER, -- Identificador del usuario que realiza el pago.
    id_categoria_transaccion NUMBER, -- Identificador de la categor�a asociada al pago.
    CONSTRAINT fk_pagos_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario), -- Llave for�nea que relaciona el pago con el usuario.
    CONSTRAINT fk_pagos_categoria FOREIGN KEY (id_categoria_transaccion) REFERENCES Categoria_Transaccion(id_categoria_transaccion) -- Llave for�nea que relaciona el pago con la categor�a de transacci�n.
);

-- Tabla: Transacciones
-- Registra las transacciones financieras realizadas por los usuarios.
CREATE TABLE Transacciones (
    id_transaccion NUMBER(8) PRIMARY KEY, -- Identificador �nico de la transacci�n.
    descripcion VARCHAR2(200), -- Descripci�n de la transacci�n.
    monto NUMBER(12, 2), -- Monto de la transacci�n.
    tipo VARCHAR2(2), -- Tipo de transacci�n (ejemplo: ingreso, gasto).
    fecha_movimiento DATE, -- Fecha de la transacci�n.
    tipo_moneda VARCHAR2(3), -- Tipo de moneda utilizada en la transacci�n.
    created_at TIMESTAMP, -- Fecha y hora de creaci�n del registro.
    updated_at TIMESTAMP, -- Fecha y hora de la �ltima actualizaci�n del registro.
    id_usuario NUMBER, -- Identificador del usuario que realiz� la transacci�n.
    id_categoria_transaccion NUMBER, -- Identificador de la categor�a de transacci�n.
    CONSTRAINT fk_transacciones_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario), -- Llave for�nea que relaciona la transacci�n con el usuario.
    CONSTRAINT fk_transacciones_categoria FOREIGN KEY (id_categoria_transaccion) REFERENCES Categoria_Transaccion(id_categoria_transaccion) -- Llave for�nea que relaciona la transacci�n con la categor�a.
);

-- Tabla: Recordatorios_Usuarios
-- Vincula recordatorios con los usuarios.
CREATE TABLE Recordatorios_Usuarios (
    id_recordatorio NUMBER, -- Identificador del recordatorio.
    id_usuario NUMBER, -- Identificador del usuario.
    CONSTRAINT fk_recordatorios FOREIGN KEY (id_recordatorio) REFERENCES Recordatorios(id_recordatorio), -- Llave for�nea que relaciona el recordatorio con su registro en la tabla Recordatorios.
    CONSTRAINT fk_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) -- Llave for�nea que relaciona el recordatorio con el usuario.
);
--------------------------------------------------------------------------------------------------------------PROCEDIMIENTOS CRUD --------------------------------------------------------------------------------------------------------------
--****************************USUARIO***************************************

--Procedimiento: Crear Usuario
-- Este procedimiento permite insertar un nuevo usuario en la tabla "Usuarios"
-- Recibe la c�dula (id_usuario), nombre, apellidos, tel�fono, email, foto de perfil y el rol del usuario
CREATE OR REPLACE PROCEDURE SP_CREAR_USUARIO (
    p_id_usuario IN NUMBER,   -- Par�metro para la c�dula (id_usuario)
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
        p_id_usuario,             -- La c�dula como id_usuario
        p_nombre,                 -- Nombre del usuario
        p_primer_apellido,        -- Primer apellido del usuario
        p_segundo_apellido,       -- Segundo apellido del usuario
        p_numero_telefono,        -- N�mero de tel�fono del usuario
        p_email,                  -- Email del usuario
        p_foto_perfil_url,        -- Foto de perfil del usuario
        SYSDATE,                  -- Fecha de creaci�n
        SYSDATE,                  -- Fecha de actualizaci�n
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
        numero_telefono = p_numero_telefono,   -- Actualizar tel�fono
        email = p_email,                    -- Actualizar email
        foto_perfil_url = p_foto_perfil_url,  -- Actualizar foto de perfil
        updated_at = SYSTIMESTAMP,          -- Fecha de actualizaci�n
        id_rol = p_id_rol                   -- Actualizar rol
    WHERE id_usuario = p_id_usuario;        -- Buscar el usuario por su c�dula
    COMMIT;  -- Confirmar la transacci�n
END;
/

--Procedimiento: Eliminar Usuario
-- Este procedimiento permite eliminar un usuario por su c�dula (id_usuario)
CREATE OR REPLACE PROCEDURE sp_eliminar_usuario (
    p_id_usuario IN NUMBER  -- c�dula del usuario a eliminar
) AS
BEGIN
    -- Eliminar el usuario de la tabla "Usuarios" usando su id_usuario
    DELETE FROM Usuarios WHERE id_usuario = p_id_usuario;
    COMMIT;  -- Confirmar la transacci�n
END;
/

--****************************Transacci�n***************************************

-- Crear una secuencia para generar id_transaccion de forma autom�tica
CREATE SEQUENCE seq_id_transaccion
START WITH 1  -- Iniciar en 1
INCREMENT BY 1  -- Incrementar en 1 por cada nueva transacci�n
NOCACHE  -- No almacenar en cach� los valores
NOCYCLE;  -- La secuencia no vuelve a empezar al llegar al valor m�ximo

--Procedimiento: Crear Transacci�n
-- Este procedimiento permite crear una nueva transacci�n en la tabla "Transacciones"
-- Recibe la descripci�n, monto, tipo de transacci�n (Ingreso o Gasto), fecha de movimiento, tipo de moneda, id_usuario y id_categoria
CREATE OR REPLACE PROCEDURE sp_crear_transaccion (
    p_descripcion        IN VARCHAR2,    -- Descripci�n de la transacci�n
    p_monto              IN NUMBER,      -- Monto de la transacci�n
    p_tipo               IN VARCHAR2,    -- Tipo de transacci�n ('I' para ingreso, 'G' para gasto)
    p_fecha_movimiento   IN DATE,        -- Fecha de la transacci�n
    p_tipo_moneda        IN VARCHAR2,    -- Tipo de moneda (ej. USD, EUR)
    p_id_usuario         IN NUMBER,      -- ID del usuario asociado a la transacci�n
    p_id_categoria       IN NUMBER       -- ID de la categor�a de la transacci�n
) AS
BEGIN
    -- Validar que el tipo de transacci�n sea 'I' o 'G'
    IF p_tipo NOT IN ('I', 'G') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Tipo inv�lido. Use "I" para ingreso o "G" para gasto.');
    END IF;

    -- Insertar una nueva transacci�n en la tabla "Transacciones"
    INSERT INTO Transacciones (
        id_transaccion, descripcion, monto, tipo, fecha_movimiento, tipo_moneda,
        created_at, updated_at, id_usuario, id_categoria_transaccion
    ) VALUES (
        seq_id_transaccion.NEXTVAL,  -- Generar el ID de la transacci�n usando la secuencia
        p_descripcion,               -- Descripci�n de la transacci�n
        p_monto,                     -- Monto de la transacci�n
        p_tipo,                      -- Tipo de transacci�n
        p_fecha_movimiento,          -- Fecha del movimiento
        p_tipo_moneda,               -- Tipo de moneda
        SYSTIMESTAMP,                -- Fecha de creaci�n
        SYSTIMESTAMP,                -- Fecha de actualizaci�n
        p_id_usuario,                -- ID del usuario que realiza la transacci�n
        p_id_categoria               -- ID de la categor�a de la transacci�n
    );
    COMMIT;  -- Confirmar la transacci�n
END;
/

--------------------------------------------------------------------------------------------------------------FUNCIONES DE VALIDACI�N--------------------------------------------------------------------------------------------------------------
--Funci�n: Verificar si un usuario existe
-- Esta funci�n retorna TRUE si un usuario con el id especificado existe en la base de datos, de lo contrario retorna FALSE
CREATE OR REPLACE FUNCTION fn_usuario_existe (
    p_id_usuario IN NUMBER  -- c�dula del usuario
) RETURN BOOLEAN AS
    v_count NUMBER;  -- Variable para contar los usuarios con el id especificado
BEGIN
    -- Contar cu�ntos usuarios tienen el id_usuario especificado
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
        EXIT WHEN c_usuarios%NOTFOUND;  -- Salir del bucle cuando no haya m�s usuarios

        -- Mostrar los datos del usuario
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_usuario.id_usuario || 
                             ', Nombre: ' || v_usuario.nombre || 
                             ', Email: ' || v_usuario.email);
    END LOOP;
    -- Cerrar el cursor
    CLOSE c_usuarios;
END;
/
   
