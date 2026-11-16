-- ============================================================
--  Florería Los Lirios — Schema de base de datos
--  MySQL 5.7+ / 8.0+
-- ============================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "-05:00"; -- Lima, Perú (UTC-5)

-- ------------------------------------------------------------
-- Crear y seleccionar la base de datos
-- ------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS `floreria_los_lirios`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `floreria_los_lirios`;

-- ------------------------------------------------------------
-- Tabla: categories
-- ------------------------------------------------------------
CREATE TABLE `categories` (
  `id`          INT UNSIGNED    NOT NULL AUTO_INCREMENT,
  `nombre`      VARCHAR(100)    NOT NULL,
  `descripcion` VARCHAR(255)        NULL DEFAULT NULL,
  `icono`       VARCHAR(10)         NULL DEFAULT NULL COMMENT 'Emoji representativo',
  `activo`      TINYINT(1)      NOT NULL DEFAULT 1,
  `created_at`  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_categories_nombre` (`nombre`)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Tabla: products
-- ------------------------------------------------------------
CREATE TABLE `products` (
  `id`           INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  `category_id`  INT UNSIGNED     NOT NULL,
  `nombre`       VARCHAR(150)     NOT NULL,
  `descripcion`  TEXT                 NULL DEFAULT NULL,
  `precio`       DECIMAL(10, 2)   NOT NULL,
  `stock`        INT UNSIGNED     NOT NULL DEFAULT 0,
  `imagen_url`   VARCHAR(500)         NULL DEFAULT NULL,
  `activo`       TINYINT(1)       NOT NULL DEFAULT 1,
  `featured`     TINYINT(1)       NOT NULL DEFAULT 0,
  `created_at`   DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_products_category`  (`category_id`),
  KEY `idx_products_activo`    (`activo`),
  KEY `idx_products_featured`  (`featured`),
  CONSTRAINT `fk_products_category`
    FOREIGN KEY (`category_id`)
    REFERENCES `categories` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Tabla: users  (solo administradores por ahora)
-- ------------------------------------------------------------
CREATE TABLE `users` (
  `id`         INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `nombre`     VARCHAR(100)  NOT NULL,
  `email`      VARCHAR(150)  NOT NULL,
  `password`   VARCHAR(255)  NOT NULL COMMENT 'bcrypt hash',
  `rol`        ENUM('admin') NOT NULL DEFAULT 'admin',
  `created_at` DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_email` (`email`)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Tabla: orders
-- ------------------------------------------------------------
CREATE TABLE `orders` (
  `id`                INT UNSIGNED    NOT NULL AUTO_INCREMENT,
  `codigo`            VARCHAR(20)     NOT NULL COMMENT 'Ej: LIR-2026-0001',
  `cliente_nombre`    VARCHAR(100)    NOT NULL,
  `cliente_apellido`  VARCHAR(100)    NOT NULL,
  `cliente_telefono`  VARCHAR(20)     NOT NULL,
  `cliente_email`     VARCHAR(150)        NULL DEFAULT NULL,
  `direccion`         VARCHAR(300)        NULL DEFAULT NULL,
  `distrito`          VARCHAR(100)        NULL DEFAULT NULL,
  `fecha_entrega`     DATE            NOT NULL,
  `hora_entrega`      TIME            NOT NULL,
  `tipo_entrega`      ENUM('delivery','recojo') NOT NULL DEFAULT 'delivery',
  `nota_dedicatoria`  TEXT                NULL DEFAULT NULL,
  `metodo_pago`       ENUM('culqi','yape','efectivo') NOT NULL DEFAULT 'efectivo',
  `estado`            ENUM(
                        'pendiente',
                        'confirmado',
                        'preparando',
                        'enviado',
                        'entregado',
                        'cancelado'
                      ) NOT NULL DEFAULT 'pendiente',
  `subtotal`          DECIMAL(10, 2)  NOT NULL DEFAULT 0.00,
  `delivery`          DECIMAL(10, 2)  NOT NULL DEFAULT 0.00,
  `total`             DECIMAL(10, 2)  NOT NULL DEFAULT 0.00,
  `culqi_token`       VARCHAR(255)        NULL DEFAULT NULL COMMENT 'Token de cargo de Culqi',
  `created_at`        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_orders_codigo`    (`codigo`),
  KEY   `idx_orders_estado`        (`estado`),
  KEY   `idx_orders_fecha_entrega` (`fecha_entrega`),
  KEY   `idx_orders_created_at`    (`created_at`),
  KEY   `idx_orders_metodo_pago`   (`metodo_pago`)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Tabla: order_items
-- ------------------------------------------------------------
CREATE TABLE `order_items` (
  `id`               INT UNSIGNED   NOT NULL AUTO_INCREMENT,
  `order_id`         INT UNSIGNED   NOT NULL,
  `product_id`       INT UNSIGNED       NULL DEFAULT NULL COMMENT 'NULL si el producto fue eliminado',
  `nombre_producto`  VARCHAR(150)   NOT NULL COMMENT 'Snapshot del nombre al momento de comprar',
  `precio_unitario`  DECIMAL(10, 2) NOT NULL,
  `cantidad`         INT UNSIGNED   NOT NULL DEFAULT 1,
  `subtotal`         DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_order_items_order`   (`order_id`),
  KEY `idx_order_items_product` (`product_id`),
  CONSTRAINT `fk_order_items_order`
    FOREIGN KEY (`order_id`)
    REFERENCES `orders` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_order_items_product`
    FOREIGN KEY (`product_id`)
    REFERENCES `products` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Vistas útiles
-- ============================================================

-- Vista: resumen de pedidos con conteo de ítems
CREATE OR REPLACE VIEW `v_orders_summary` AS
SELECT
  o.id,
  o.codigo,
  CONCAT(o.cliente_nombre, ' ', o.cliente_apellido) AS cliente,
  o.cliente_telefono,
  o.cliente_email,
  o.tipo_entrega,
  o.metodo_pago,
  o.estado,
  o.subtotal,
  o.delivery,
  o.total,
  o.fecha_entrega,
  o.hora_entrega,
  COUNT(oi.id)  AS total_items,
  SUM(oi.cantidad) AS total_unidades,
  o.created_at
FROM `orders` o
LEFT JOIN `order_items` oi ON oi.order_id = o.id
GROUP BY o.id;

-- Vista: productos con nombre de categoría
CREATE OR REPLACE VIEW `v_products_full` AS
SELECT
  p.id,
  p.nombre,
  p.descripcion,
  p.precio,
  p.stock,
  p.imagen_url,
  p.activo,
  p.featured,
  p.created_at,
  c.id    AS category_id,
  c.nombre AS category_nombre,
  c.icono  AS category_icono
FROM `products` p
INNER JOIN `categories` c ON c.id = p.category_id;

-- ============================================================
-- Procedimientos almacenados
-- ============================================================

DELIMITER $$

-- Genera el próximo código de pedido para el año actual
CREATE PROCEDURE `sp_generate_order_code`(OUT p_codigo VARCHAR(20))
BEGIN
  DECLARE v_year   CHAR(4);
  DECLARE v_count  INT;

  SET v_year  = YEAR(CURDATE());

  SELECT COUNT(*) + 1
    INTO v_count
    FROM `orders`
   WHERE YEAR(created_at) = v_year;

  SET p_codigo = CONCAT('LIR-', v_year, '-', LPAD(v_count, 4, '0'));
END$$

DELIMITER ;

-- ============================================================
-- Fin del schema
-- ============================================================
