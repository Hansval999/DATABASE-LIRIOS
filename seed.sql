-- ============================================================
--  Florería Los Lirios — Datos iniciales (seed)
--  Ejecutar DESPUÉS de schema.sql
-- ============================================================

USE `floreria_los_lirios`;

-- ============================================================
-- Categorías
-- ============================================================

INSERT INTO `categories` (`nombre`, `descripcion`, `icono`, `activo`) VALUES
('Ramos',          'Hermosos ramos de flores frescas para toda ocasión',          '💐', 1),
('Coronas',        'Coronas fúnebres y de honor elaboradas con respeto y cuidado', '🕊️', 1),
('Arreglos',       'Arreglos florales creativos en cajas, canastas y más',         '🌸', 1),
('Plantas',        'Plantas de interior y exterior para decorar tu hogar',         '🌿', 1),
('Flores sueltas', 'Flores individuales frescas para armar tu propio ramo',        '🌹', 1),
('Regalos',        'Combos especiales de flores con chocolates y más detalles',    '🎁', 1);

-- ============================================================
-- Usuario administrador
-- Contraseña: lirios2024
-- Hash generado con password_hash('lirios2024', PASSWORD_BCRYPT)
-- ============================================================

INSERT INTO `users` (`nombre`, `email`, `password`, `rol`) VALUES
(
  'Administrador',
  'admin@floreriasloslirios.com',
  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
  'admin'
);

-- NOTA: el hash de arriba es el hash oficial de bcrypt para la cadena "password"
-- (usado en tests de Laravel). Para producción, generar uno nuevo con:
--   php -r "echo password_hash('lirios2024', PASSWORD_BCRYPT);"
-- y reemplazar el valor aquí y en AuthController.php

-- ============================================================
-- Productos
-- Orden: category_id según el INSERT de categories:
--   1=Ramos | 2=Coronas | 3=Arreglos | 4=Plantas | 5=Flores sueltas | 6=Regalos
-- ============================================================

INSERT INTO `products`
  (`category_id`, `nombre`, `descripcion`, `precio`, `stock`, `imagen_url`, `activo`, `featured`)
VALUES

-- === Ramos (category_id = 1) ===
(
  1,
  'Ramo de Rosas Rojas x12',
  'Doce rosas rojas frescas cuidadosamente seleccionadas, envueltas en papel kraft y lazo de satén. El regalo clásico que nunca falla para expresar amor y pasión.',
  45.00, 20,
  'https://placehold.co/400x400/e63946/ffffff?text=Rosas+Rojas',
  1, 1
),
(
  1,
  'Ramo Primaveral Mixto',
  'Colorido ramo con flores de temporada: girasoles, margaritas, alstroemerias y follaje verde. Perfecto para alegrar cualquier espacio o regalar en cumpleaños.',
  38.00, 15,
  'https://placehold.co/400x400/95d5b2/ffffff?text=Ramo+Primaveral',
  1, 1
),
(
  1,
  'Ramo de Liliums',
  'Elegante ramo de liliums blancos y rosados, flores reconocidas por su fragancia suave y su porte sofisticado. Ideal para ocasiones especiales y aniversarios.',
  50.00, 14,
  'https://placehold.co/400x400/f4a7b9/ffffff?text=Liliums',
  1, 0
),
(
  1,
  'Ramo Romántico Rojo',
  'Arreglo de rosas rojas, tulipanes y flores de temporada en tonos rojos y borgoña, con decoración premium. Diseñado para sorprender en San Valentín, aniversarios y momentos especiales.',
  60.00, 10,
  'https://placehold.co/400x400/c1121f/ffffff?text=Ramo+Romantico',
  1, 1
),

-- === Coronas (category_id = 2) ===
(
  2,
  'Corona Fúnebre Grande',
  'Corona fúnebre elaborada con flores blancas y verdes: crisantemos, liliums y follaje selecto. Diseño clásico y respetuoso para expresar condolencias con dignidad.',
  120.00, 10,
  'https://placehold.co/400x400/6c757d/ffffff?text=Corona+Funebre',
  1, 0
),

-- === Arreglos (category_id = 3) ===
(
  3,
  'Arreglo en Caja Vintage',
  'Flores frescas cuidadosamente dispuestas en una elegante caja de madera estilo vintage. Incluye rosas, peonías y flores de temporada. Listo para regalar sin necesidad de florero.',
  65.00, 12,
  'https://placehold.co/400x400/d4a373/ffffff?text=Caja+Vintage',
  1, 1
),
(
  3,
  'Arreglo de Temporada',
  'Arreglo floral diseñado con las flores más frescas disponibles cada semana. Colores y variedades según temporada, siempre fresco y vibrante. Perfecto para decorar o regalar.',
  42.00, 20,
  'https://placehold.co/400x400/2d6a4f/ffffff?text=Arreglo+Temporada',
  1, 0
),
(
  3,
  'Caja de Rosas Premium x24',
  'Veinticuatro rosas de tallo largo en una lujosa caja negra con tapa, decoradas con papel seda y lazo de terciopelo. El regalo más impactante para una declaración de amor.',
  95.00, 6,
  'https://placehold.co/400x400/1d1d1d/ffffff?text=Caja+Premium+x24',
  1, 1
),

-- === Plantas (category_id = 4) ===
(
  4,
  'Orquídea en Maceta',
  'Hermosa orquídea Phalaenopsis en maceta decorativa de cerámica. Planta de interior de larga duración con flores que pueden durar hasta 3 meses. Incluye instrucciones de cuidado.',
  80.00, 8,
  'https://placehold.co/400x400/b388ff/ffffff?text=Orquidea',
  1, 1
),
(
  4,
  'Planta Suculenta Decorativa',
  'Composición de suculentas variadas en maceta de terracota pintada a mano. Plantas resistentes que requieren mínimo cuidado, ideales para oficinas, escritorios y personas ocupadas.',
  25.00, 30,
  'https://placehold.co/400x400/52b788/ffffff?text=Suculenta',
  1, 0
),

-- === Flores sueltas (category_id = 5) ===
(
  5,
  'Girasoles x6',
  'Seis girasoles frescos de tallo largo, símbolo de alegría y energía positiva. Perfectos para armar tu propio arreglo en casa o regalar tal cual. Duración estimada: 7-10 días.',
  30.00, 25,
  'https://placehold.co/400x400/ffd166/ffffff?text=Girasoles+x6',
  1, 0
),
(
  5,
  'Tulipanes x10',
  'Diez tulipanes en colores mixtos (rojo, amarillo, lila y blanco) de primera calidad importados. Flores elegantes con una vida en florero de 5-7 días. Llegada fresca garantizada.',
  55.00, 18,
  'https://placehold.co/400x400/e9c46a/ffffff?text=Tulipanes+x10',
  1, 1
);

-- ============================================================
-- Pedido de ejemplo (opcional — para ver el panel admin)
-- ============================================================

INSERT INTO `orders` (
  `codigo`, `cliente_nombre`, `cliente_apellido`, `cliente_telefono`, `cliente_email`,
  `direccion`, `distrito`, `fecha_entrega`, `hora_entrega`,
  `tipo_entrega`, `nota_dedicatoria`, `metodo_pago`, `estado`,
  `subtotal`, `delivery`, `total`, `created_at`
) VALUES (
  'LIR-2026-0001',
  'María', 'García', '987654321', 'maria@example.com',
  'Av. Huaylas 123', 'Chorrillos',
  DATE_ADD(CURDATE(), INTERVAL 1 DAY), '10:00:00',
  'delivery', 'Con mucho cariño para ti ❤️',
  'yape', 'pendiente',
  83.00, 10.00, 93.00,
  NOW()
);

-- Ítems del pedido de ejemplo
INSERT INTO `order_items` (`order_id`, `product_id`, `nombre_producto`, `precio_unitario`, `cantidad`, `subtotal`)
VALUES
  (1, 1, 'Ramo de Rosas Rojas x12', 45.00, 1, 45.00),
  (1, 2, 'Ramo Primaveral Mixto',   38.00, 1, 38.00);

-- ============================================================
-- Verificación rápida al ejecutar
-- ============================================================

SELECT 'categories' AS tabla, COUNT(*) AS registros FROM categories
UNION ALL
SELECT 'products',   COUNT(*) FROM products
UNION ALL
SELECT 'users',      COUNT(*) FROM users
UNION ALL
SELECT 'orders',     COUNT(*) FROM orders
UNION ALL
SELECT 'order_items',COUNT(*) FROM order_items;

-- ============================================================
-- Fin del seed
-- ============================================================
