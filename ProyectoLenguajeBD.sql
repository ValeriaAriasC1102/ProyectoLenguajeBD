-- Tabla: Roles_Usuario
-- Esta tabla almacena los roles que puede tener un usuario dentro del sistema.
CREATE TABLE Roles_Usuario (
    id_rol NUMBER(2) PRIMARY KEY, -- Identificador único del rol.
    nombre VARCHAR2(50), -- Nombre del rol.
    descripcion VARCHAR2(250) -- Descripción del rol.
);

-- Tabla: Usuarios
-- Contiene información sobre los usuarios registrados en el sistema.
CREATE TABLE Usuarios (
    id_usuario NUMBER PRIMARY KEY, -- Identificador único del usuario.
    nombre VARCHAR2(100), -- Nombre del usuario.
    primer_apellido VARCHAR2(100), -- Primer apellido del usuario.
    segundo_apellido VARCHAR2(100), -- Segundo apellido del usuario.
    numero_telefono VARCHAR2(15), -- Número de teléfono del usuario.
    email VARCHAR2(200), -- Dirección de correo electrónico del usuario.
    foto_perfil_url VARCHAR2(250), -- URL de la foto de perfil del usuario.
    created_at TIMESTAMP, -- Fecha y hora de creación del registro.
    updated_at TIMESTAMP, -- Fecha y hora de la última actualización del registro.
    id_rol NUMBER(2), -- Rol asignado al usuario.
    CONSTRAINT fk_usuarios_roles FOREIGN KEY (id_rol) REFERENCES Roles_Usuario(id_rol) -- Llave foránea que relaciona el rol del usuario.
);

CREATE SEQUENCE seq_usuario
START WITH 1
INCREMENT BY 1
NOCACHE;


-- Tabla: Categoria_Transaccion
-- Define las categorías de las transacciones que pueden registrarse en el sistema.
CREATE TABLE Categoria_Transaccion (
    id_categoria_transaccion NUMBER PRIMARY KEY, -- Identificador único de la categoría de transacción.
    nombre VARCHAR2(60), -- Nombre de la categoría.
    tipo_categoria VARCHAR2(20), -- Tipo de la categoría (ejemplo: ingreso, gasto).
    categoria_transaccion_id NUMBER, -- Relación jerárquica con otra categoría.
    CONSTRAINT fk_categoria_transaccion_padre FOREIGN KEY (categoria_transaccion_id) REFERENCES Categoria_Transaccion(id_categoria_transaccion) -- Llave foránea a la categoría padre.
);

-- Tabla: Recordatorios
-- Registra los recordatorios configurados por los usuarios.
CREATE TABLE Recordatorios (
    id_recordatorio NUMBER PRIMARY KEY, -- Identificador único del recordatorio.
    id_event VARCHAR2(10), -- Código del evento asociado al recordatorio.
    descripcion_event VARCHAR2(30), -- Descripción del evento.
    descripcion VARCHAR2(60) -- Descripción general del recordatorio.
);

-- Tabla: Colecciones
-- Permite agrupar datos en colecciones específicas.
CREATE TABLE Colecciones (
    id_coleccion NUMBER(8) PRIMARY KEY, -- Identificador único de la colección.
    nombre_coleccion VARCHAR2(50), -- Nombre de la colección.
    nombre VARCHAR2(30), -- Nombre asociado dentro de la colección.
    value VARCHAR2(50) -- Valor almacenado en la colección.
);

-- Tabla: Cuentas
-- Almacena información sobre las cuentas financieras de los usuarios.
CREATE TABLE Cuentas (
    id_cuenta NUMBER(12) PRIMARY KEY, -- Identificador único de la cuenta.
    nombre VARCHAR2(70), -- Nombre de la cuenta.
    nombre_entidad_financiera VARCHAR2(8), -- Nombre de la entidad financiera.
    tipo_moneda VARCHAR2(3), -- Tipo de moneda (ejemplo: USD, EUR).
    dinero_monto NUMBER(22, 2), -- Monto disponible en la cuenta.
    created_at TIMESTAMP, -- Fecha y hora de creación del registro.
    updated_at TIMESTAMP, -- Fecha y hora de la última actualización del registro.
    id_usuario NUMBER, -- Identificador del usuario dueño de la cuenta.
    CONSTRAINT fk_cuentas_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) -- Llave foránea que relaciona la cuenta con el usuario.
);

-- Tabla: Objetivos
-- Define objetivos financieros que los usuarios desean alcanzar.
CREATE TABLE Objetivos (
    id_objetivo NUMBER PRIMARY KEY, -- Identificador único del objetivo.
    nombre VARCHAR2(50), -- Nombre del objetivo.
    tipo_objetivo VARCHAR2(20), -- Tipo del objetivo (ejemplo: ahorro, inversión).
    fecha_inicio DATE, -- Fecha de inicio del objetivo.
    fecha_tope DATE, -- Fecha límite para alcanzar el objetivo.
    monto_actual NUMBER(12, 2), -- Monto acumulado hasta el momento.
    monto_meta NUMBER(12, 2), -- Monto meta a alcanzar.
    id_usuario NUMBER, -- Identificador del usuario dueño del objetivo.
    categoria_transaccion_id NUMBER, -- Identificador de la categoría de transacción asociada.
    CONSTRAINT fk_objetivos_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario), -- Llave foránea que relaciona el objetivo con el usuario.
    CONSTRAINT fk_objetivos_categoria FOREIGN KEY (categoria_transaccion_id) REFERENCES Categoria_Transaccion(id_categoria_transaccion) -- Llave foránea a la categoría de transacción.
);

-- Tabla: Presupuestos
-- Registra presupuestos financieros asignados por los usuarios.
CREATE TABLE Presupuestos (
    id_presupuesto NUMBER PRIMARY KEY, -- Identificador único del presupuesto.
    monto_total NUMBER(12,2), -- Monto total del presupuesto.
    is_principal NUMBER(1), -- Indica si el presupuesto es el principal (1: sí, 0: no).
    estado NUMBER(1), -- Estado del presupuesto (ejemplo: activo, inactivo).
    created_at TIMESTAMP, -- Fecha y hora de creación del registro.
    updated_at TIMESTAMP, -- Fecha y hora de la última actualización del registro.
    id_usuario NUMBER, -- Identificador del usuario dueño del presupuesto.
    CONSTRAINT fk_presupuestos_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) -- Llave foránea que relaciona el presupuesto con el usuario.
);

-- Tabla: Ahorros
-- Almacena registros sobre los ahorros de los usuarios.
CREATE TABLE Ahorros (
    id_ahorro NUMBER(4) PRIMARY KEY, -- Identificador único del ahorro.
    ahorro_nombre VARCHAR2(50), -- Nombre del ahorro.
    monto NUMBER(18, 2), -- Monto total del ahorro.
    frecuencia VARCHAR2(20), -- Frecuencia de ahorro (ejemplo: mensual, semanal).
    descripcion VARCHAR2(150), -- Descripción del ahorro.
    fecha_inicio DATE, -- Fecha de inicio del ahorro.
    fecha_final DATE, -- Fecha de finalización del ahorro.
    created_at TIMESTAMP, -- Fecha y hora de creación del registro.
    updated_at TIMESTAMP, -- Fecha y hora de la última actualización del registro.
    id_usuario NUMBER, -- Identificador del usuario dueño del ahorro.
    id_objetivo NUMBER, -- Identificador del objetivo asociado al ahorro.
    CONSTRAINT fk_ahorros_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario), -- Llave foránea que relaciona el ahorro con el usuario.
    CONSTRAINT fk_ahorros_objetivo FOREIGN KEY (id_objetivo) REFERENCES Objetivos(id_objetivo) -- Llave foránea que relaciona el ahorro con el objetivo.
);

-- Tabla: Pagos
-- Contiene información sobre pagos programados por los usuarios.
CREATE TABLE Pagos (
    id_pago NUMBER PRIMARY KEY, -- Identificador único del pago.
    nombre VARCHAR2(50), -- Nombre del pago.
    monto NUMBER(12, 2), -- Monto del pago.
    frecuencia VARCHAR2(20), -- Frecuencia del pago (ejemplo: mensual, anual).
    fecha_inicio DATE, -- Fecha de inicio del pago.
    fecha_final DATE, -- Fecha de finalización del pago.
    created_at TIMESTAMP, -- Fecha y hora de creación del registro.
    updated_at TIMESTAMP, -- Fecha y hora de la última actualización del registro.
    id_usuario NUMBER, -- Identificador del usuario que realiza el pago.
    id_categoria_transaccion NUMBER, -- Identificador de la categoría asociada al pago.
    CONSTRAINT fk_pagos_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario), -- Llave foránea que relaciona el pago con el usuario.
    CONSTRAINT fk_pagos_categoria FOREIGN KEY (id_categoria_transaccion) REFERENCES Categoria_Transaccion(id_categoria_transaccion) -- Llave foránea que relaciona el pago con la categoría de transacción.
);

-- Tabla: Transacciones
-- Registra las transacciones financieras realizadas por los usuarios.
CREATE TABLE Transacciones (
    id_transaccion NUMBER(8) PRIMARY KEY, -- Identificador único de la transacción.
    descripcion VARCHAR2(200), -- Descripción de la transacción.
    monto NUMBER(12, 2), -- Monto de la transacción.
    tipo VARCHAR2(2), -- Tipo de transacción (ejemplo: ingreso, gasto).
    fecha_movimiento DATE, -- Fecha de la transacción.
    tipo_moneda VARCHAR2(3), -- Tipo de moneda utilizada en la transacción.
    created_at TIMESTAMP, -- Fecha y hora de creación del registro.
    updated_at TIMESTAMP, -- Fecha y hora de la última actualización del registro.
    id_usuario NUMBER, -- Identificador del usuario que realizó la transacción.
    id_categoria_transaccion NUMBER, -- Identificador de la categoría de transacción.
    CONSTRAINT fk_transacciones_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario), -- Llave foránea que relaciona la transacción con el usuario.
    CONSTRAINT fk_transacciones_categoria FOREIGN KEY (id_categoria_transaccion) REFERENCES Categoria_Transaccion(id_categoria_transaccion) -- Llave foránea que relaciona la transacción con la categoría.
);

-- Tabla: Recordatorios_Usuarios
-- Vincula recordatorios con los usuarios.
CREATE TABLE Recordatorios_Usuarios (
    id_recordatorio NUMBER, -- Identificador del recordatorio.
    id_usuario NUMBER, -- Identificador del usuario.
    CONSTRAINT fk_recordatorios FOREIGN KEY (id_recordatorio) REFERENCES Recordatorios(id_recordatorio), -- Llave foránea que relaciona el recordatorio con su registro en la tabla Recordatorios.
    CONSTRAINT fk_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) -- Llave foránea que relaciona el recordatorio con el usuario.
);
--------------------------------------------------------------------------------------------------------------PROCEDIMIENTOS CRUD --------------------------------------------------------------------------------------------------------------
--****************************USUARIO***************************************

--Procedimiento: Crear Usuario
-- Este procedimiento permite insertar un nuevo usuario en la tabla "Usuarios"
-- Recibe la cédula (id_usuario), nombre, apellidos, teléfono, email, foto de perfil y el rol del usuario
CREATE OR REPLACE PROCEDURE SP_CREAR_USUARIO (
    p_id_usuario IN NUMBER,   -- Parámetro para la cédula (id_usuario)
    p_nombre IN VARCHAR2,     -- Nombre del usuario
    p_primer_apellido IN VARCHAR2,  -- Primer apellido del usuario
    p_segundo_apellido IN VARCHAR2, -- Segundo apellido del usuario
    p_numero_telefono IN VARCHAR2,  -- Número de teléfono del usuario
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
        p_id_usuario,             -- La cédula como id_usuario
        p_nombre,                 -- Nombre del usuario
        p_primer_apellido,        -- Primer apellido del usuario
        p_segundo_apellido,       -- Segundo apellido del usuario
        p_numero_telefono,        -- Número de teléfono del usuario
        p_email,                  -- Email del usuario
        p_foto_perfil_url,        -- Foto de perfil del usuario
        SYSDATE,                  -- Fecha de creación
        SYSDATE,                  -- Fecha de actualización
        p_id_rol                  -- Rol del usuario
    );

    COMMIT;  -- Confirmar la transacción
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
-- Recibe la cédula (id_usuario) y los nuevos valores para los campos del usuario
CREATE OR REPLACE PROCEDURE sp_actualizar_usuario (
    p_id_usuario        IN NUMBER,      -- cédula del usuario a actualizar
    p_nombre            IN VARCHAR2,    -- Nuevo nombre del usuario
    p_primer_apellido   IN VARCHAR2,    -- Nuevo primer apellido
    p_segundo_apellido  IN VARCHAR2,    -- Nuevo segundo apellido
    p_numero_telefono   IN VARCHAR2,    -- Nuevo número de teléfono
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
        numero_telefono = p_numero_telefono,   -- Actualizar teléfono
        email = p_email,                    -- Actualizar email
        foto_perfil_url = p_foto_perfil_url,  -- Actualizar foto de perfil
        updated_at = SYSTIMESTAMP,          -- Fecha de actualización
        id_rol = p_id_rol                   -- Actualizar rol
    WHERE id_usuario = p_id_usuario;        -- Buscar el usuario por su cédula
    COMMIT;  -- Confirmar la transacción
END;
/

--Procedimiento: Eliminar Usuario
-- Este procedimiento permite eliminar un usuario por su cédula (id_usuario)
CREATE OR REPLACE PROCEDURE sp_eliminar_usuario (
    p_id_usuario IN NUMBER  -- cédula del usuario a eliminar
) AS
BEGIN
    -- Eliminar el usuario de la tabla "Usuarios" usando su id_usuario
    DELETE FROM Usuarios WHERE id_usuario = p_id_usuario;
    COMMIT;  -- Confirmar la transacción
END;
/

--****************************Transacción***************************************

-- Crear una secuencia para generar id_transaccion de forma automática
CREATE SEQUENCE seq_id_transaccion
START WITH 1  -- Iniciar en 1
INCREMENT BY 1  -- Incrementar en 1 por cada nueva transacción
NOCACHE  -- No almacenar en caché los valores
NOCYCLE;  -- La secuencia no vuelve a empezar al llegar al valor máximo

--Procedimiento: Crear Transacción
-- Este procedimiento permite crear una nueva transacción en la tabla "Transacciones"
-- Recibe la descripción, monto, tipo de transacción (Ingreso o Gasto), fecha de movimiento, tipo de moneda, id_usuario y id_categoria
CREATE OR REPLACE PROCEDURE sp_crear_transaccion (
    p_descripcion        IN VARCHAR2,    -- Descripción de la transacción
    p_monto              IN NUMBER,      -- Monto de la transacción
    p_tipo               IN VARCHAR2,    -- Tipo de transacción ('I' para ingreso, 'G' para gasto)
    p_fecha_movimiento   IN DATE,        -- Fecha de la transacción
    p_tipo_moneda        IN VARCHAR2,    -- Tipo de moneda (ej. USD, EUR)
    p_id_usuario         IN NUMBER,      -- ID del usuario asociado a la transacción
    p_id_categoria       IN NUMBER       -- ID de la categoría de la transacción
) AS
BEGIN
    -- Validar que el tipo de transacción sea 'I' o 'G'
    IF p_tipo NOT IN ('I', 'G') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Tipo inválido. Use "I" para ingreso o "G" para gasto.');
    END IF;

    -- Insertar una nueva transacción en la tabla "Transacciones"
    INSERT INTO Transacciones (
        id_transaccion, descripcion, monto, tipo, fecha_movimiento, tipo_moneda,
        created_at, updated_at, id_usuario, id_categoria_transaccion
    ) VALUES (
        seq_id_transaccion.NEXTVAL,  -- Generar el ID de la transacción usando la secuencia
        p_descripcion,               -- Descripción de la transacción
        p_monto,                     -- Monto de la transacción
        p_tipo,                      -- Tipo de transacción
        p_fecha_movimiento,          -- Fecha del movimiento
        p_tipo_moneda,               -- Tipo de moneda
        SYSTIMESTAMP,                -- Fecha de creación
        SYSTIMESTAMP,                -- Fecha de actualización
        p_id_usuario,                -- ID del usuario que realiza la transacción
        p_id_categoria               -- ID de la categoría de la transacción
    );
    COMMIT;  -- Confirmar la transacción
END;
/

--------------------------------------------------------------------------------------------------------------FUNCIONES DE VALIDACIÓN--------------------------------------------------------------------------------------------------------------
--Función: Verificar si un usuario existe
-- Esta función retorna TRUE si un usuario con el id especificado existe en la base de datos, de lo contrario retorna FALSE
CREATE OR REPLACE FUNCTION fn_usuario_existe (
    p_id_usuario IN NUMBER  -- cédula del usuario
) RETURN BOOLEAN AS
    v_count NUMBER;  -- Variable para contar los usuarios con el id especificado
BEGIN
    -- Contar cuántos usuarios tienen el id_usuario especificado
    SELECT COUNT(*) INTO v_count
    FROM Usuarios
    WHERE id_usuario = p_id_usuario;

    -- Retornar TRUE si el usuario existe (v_count > 0), de lo contrario FALSE
    RETURN v_count > 0;
END;
/

--------------------------------------------------------------------------------------------------------------CURSORES--------------------------------------------------------------------------------------------------------------

--Procedimiento: Iterar sobre usuarios con un rol específico
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
        EXIT WHEN c_usuarios%NOTFOUND;  -- Salir del bucle cuando no haya más usuarios

        -- Mostrar los datos del usuario
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_usuario.id_usuario || 
                             ', Nombre: ' || v_usuario.nombre || 
                             ', Email: ' || v_usuario.email);
    END LOOP;
    -- Cerrar el cursor
    CLOSE c_usuarios;
END;
/
   
