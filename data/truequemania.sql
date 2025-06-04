
DROP TABLE IF EXISTS userplantruequemania;
DROP TABLE IF EXISTS plantruequemania;
DROP TABLE IF EXISTS returnordertruequemania;
DROP TABLE IF EXISTS opiniontruequemania;
DROP TABLE IF EXISTS orderstruequemania;
DROP TABLE IF EXISTS complaintstruequemania;
DROP TABLE IF EXISTS notificationstruequemania;
DROP TABLE IF EXISTS messagestruequemania;
DROP TABLE IF EXISTS favoritetruequemania;
DROP TABLE IF EXISTS commentarticletruequemania;
DROP TABLE IF EXISTS article_imagestruequemania;
DROP TABLE IF EXISTS chatstruequemania;
DROP TABLE IF EXISTS articletruequemania;
DROP TABLE IF EXISTS datausertruequemania;
DROP TABLE IF EXISTS userimagestruequemania;
DROP TABLE IF EXISTS usertruequemania;
DROP TABLE IF EXISTS categorytruequemania;
DROP TABLE IF EXISTS settingstruequemania;
DROP TABLE IF EXISTS plantruequemania;
DROP TABLE IF EXISTS userplantruequemania;

CREATE TABLE settingstruequemania (
  id SERIAL PRIMARY KEY,
  maintenance_mode BOOLEAN DEFAULT FALSE
);

CREATE TABLE usertruequemania (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    lastName VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    isVerified BOOLEAN,
    role ENUM('superadmin', 'admin', 'client') NOT NULL DEFAULT 'client',
    PRIMARY KEY (id),
    UNIQUE KEY email (email)
);

CREATE TABLE datausertruequemania (
    id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    tipo_documento VARCHAR(50) NOT NULL,
    numero_documento VARCHAR(100) NOT NULL,
    genero ENUM('Masculino', 'Femenino', 'No identificado') NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES usertruequemania(id) ON DELETE CASCADE
);

CREATE TABLE userimagestruequemania (
    id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    url VARCHAR(500) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES usertruequemania(id) ON DELETE CASCADE
);

CREATE TABLE categorytruequemania (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT NOT NULL,
    imagen VARCHAR(500),
    PRIMARY KEY (id),
    UNIQUE KEY nombre (nombre)
);

CREATE TABLE articletruequemania (
    id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    categoria_id INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    descripcion_corta TEXT,
    descripcion_larga TEXT,
    marca VARCHAR(255),
    precio DECIMAL(10,2) DEFAULT 0,
    impuesto INT NOT NULL,
    precioImpuesto DECIMAL(10,2) DEFAULT 0,
    estado VARCHAR(255) NOT NULL,
    status_orden ENUM('ninguno', 'intercambiado', 'comprado') DEFAULT 'ninguno',
    aprobado BOOLEAN DEFAULT false,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES usertruequemania(id) ON DELETE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES categorytruequemania(id) ON DELETE CASCADE
);

CREATE TABLE article_imagestruequemania (
    id INT NOT NULL AUTO_INCREMENT,
    article_id INT NOT NULL,
    url VARCHAR(500) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (article_id) REFERENCES articletruequemania(id) ON DELETE CASCADE
);

CREATE TABLE favoritetruequemania (
    id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    articulo_id INT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES usertruequemania(id) ON DELETE CASCADE,
    FOREIGN KEY (articulo_id) REFERENCES articletruequemania(id) ON DELETE CASCADE
);

CREATE TABLE commentarticletruequemania (
    id INT NOT NULL AUTO_INCREMENT,
    articulo_id INT NOT NULL,
    comentario TEXT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (articulo_id) REFERENCES articletruequemania(id) ON DELETE CASCADE
);

CREATE TABLE chatstruequemania (
    id INT NOT NULL AUTO_INCREMENT,
    user_one_id INT NOT NULL,
    user_two_id INT NOT NULL,
    articulo_id INT NOT NULL,
    articulo_dos_id INT DEFAULT NULL,
    nameChange VARCHAR(255) NOT NULL,
    cancel_status ENUM('none', 'pending', 'accepted', 'rejected') DEFAULT 'none',
    cancel_requester_id INT DEFAULT NULL,
    cancel_reason TEXT DEFAULT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (user_one_id) REFERENCES usertruequemania(id) ON DELETE CASCADE,
    FOREIGN KEY (user_two_id) REFERENCES usertruequemania(id) ON DELETE CASCADE,
    FOREIGN KEY (articulo_id) REFERENCES articletruequemania(id) ON DELETE CASCADE,
    FOREIGN KEY (articulo_dos_id) REFERENCES articletruequemania(id) ON DELETE CASCADE,
    FOREIGN KEY (cancel_requester_id) REFERENCES usertruequemania(id) ON DELETE SET NULL
);

CREATE TABLE messagestruequemania (
    id INT NOT NULL AUTO_INCREMENT,
    chat_id INT NOT NULL,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (chat_id) REFERENCES chatstruequemania(id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES usertruequemania(id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES usertruequemania(id) ON DELETE CASCADE
);

CREATE TABLE notificationstruequemania (
    id INT AUTO_INCREMENT PRIMARY KEY,
    userId INT NOT NULL,
    chatId INT NOT NULL,
    isRead BOOLEAN DEFAULT FALSE,
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES usertruequemania(id) ON DELETE CASCADE,
    FOREIGN KEY (chatId) REFERENCES chatstruequemania(id) ON DELETE CASCADE
);

CREATE TABLE complaintstruequemania (
    id INT AUTO_INCREMENT PRIMARY KEY,
    chat_id INT NOT NULL,
    motivo VARCHAR(255) NOT NULL,
    descripcion TEXT NOT NULL,
    estado ENUM('pendiente', 'resuelto', 'rechazado') DEFAULT 'pendiente',
    resolucion_mensaje TEXT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (chat_id) REFERENCES chatstruequemania(id) ON DELETE CASCADE
);

CREATE TABLE orderstruequemania (
    id INT NOT NULL AUTO_INCREMENT,
    chat_id INT NOT NULL,
    status ENUM('pending', 'accepted', 'declined') DEFAULT 'pending',
    requester_id INT DEFAULT NULL,
    decline_reason TEXT DEFAULT NULL,
    status_envio ENUM('pendiente', 'enviado') DEFAULT 'pendiente',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (chat_id) REFERENCES chatstruequemania(id) ON DELETE CASCADE,
    FOREIGN KEY (requester_id) REFERENCES usertruequemania(id) ON DELETE SET NULL
);

CREATE TABLE returnordertruequemania (
    id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    order_id INT NOT NULL,
    motivo TEXT NOT NULL,
    estado_producto VARCHAR(100) NOT NULL,
    numero_contacto VARCHAR(20),
    estado VARCHAR(50) DEFAULT 'pendiente',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES usertruequemania(id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orderstruequemania(id) ON DELETE CASCADE
);

CREATE TABLE opiniontruequemania (
    id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    descripcion TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES usertruequemania(id) ON DELETE CASCADE
);

CREATE TABLE plantruequemania (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    limite_publicaciones INT NOT NULL,
    limite_intercambios INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    es_activo BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (id),
    UNIQUE KEY nombre (nombre)
);

CREATE TABLE userplantruequemania (
    id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    plan_id INT NOT NULL,
    fecha_inicio DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_fin DATETIME,
    es_activo BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES usertruequemania(id) ON DELETE CASCADE,
    FOREIGN KEY (plan_id) REFERENCES plantruequemania(id) ON DELETE CASCADE
);





