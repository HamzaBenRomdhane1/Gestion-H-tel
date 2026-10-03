-- ============================================
--  Gestion Hôtel - Script SQL
--  SGBD: MySQL
-- ============================================

CREATE DATABASE IF NOT EXISTS hotel_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hotel_db;

-- Table: utilisateurs (Admin / Réceptionniste)
CREATE TABLE IF NOT EXISTS utilisateurs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    role ENUM('ADMIN','RECEPTIONNISTE') NOT NULL DEFAULT 'RECEPTIONNISTE',
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: chambres
CREATE TABLE IF NOT EXISTS chambres (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(10) UNIQUE NOT NULL,
    type ENUM('SIMPLE','DOUBLE','SUITE','DELUXE') NOT NULL,
    prix_nuit DECIMAL(10,2) NOT NULL,
    capacite INT NOT NULL DEFAULT 1,
    disponible BOOLEAN NOT NULL DEFAULT TRUE,
    description TEXT
);

-- Table: clients
CREATE TABLE IF NOT EXISTS clients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telephone VARCHAR(20),
    adresse TEXT,
    cin VARCHAR(20) UNIQUE,
    date_inscription DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: reservations
CREATE TABLE IF NOT EXISTS reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    chambre_id INT NOT NULL,
    utilisateur_id INT NOT NULL,
    date_arrivee DATE NOT NULL,
    date_depart DATE NOT NULL,
    statut ENUM('EN_ATTENTE','CONFIRMEE','ANNULEE','TERMINEE') NOT NULL DEFAULT 'EN_ATTENTE',
    montant_total DECIMAL(10,2),
    date_reservation DATETIME DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
    FOREIGN KEY (chambre_id) REFERENCES chambres(id) ON DELETE CASCADE,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id)
);

-- ============================================
--  DONNÉES DE TEST
-- ============================================

-- Utilisateurs (mot de passe: admin123 / recep123 - stockés en SHA-256)
INSERT INTO utilisateurs (nom, prenom, email, mot_de_passe, role) VALUES
('Dupont', 'Jean', 'admin@hotel.com', SHA2('admin123', 256), 'ADMIN'),
('Martin', 'Sophie', 'sophie@hotel.com', SHA2('recep123', 256), 'RECEPTIONNISTE'),
('Karim', 'Ben Ali', 'karim@hotel.com', SHA2('recep123', 256), 'RECEPTIONNISTE');

-- Chambres
INSERT INTO chambres (numero, type, prix_nuit, capacite, disponible, description) VALUES
('101', 'SIMPLE', 80.00, 1, TRUE, 'Chambre simple avec vue sur jardin'),
('102', 'SIMPLE', 80.00, 1, TRUE, 'Chambre simple avec vue sur rue'),
('201', 'DOUBLE', 130.00, 2, TRUE, 'Chambre double avec balcon'),
('202', 'DOUBLE', 130.00, 2, TRUE, 'Chambre double standard'),
('301', 'DELUXE', 200.00, 2, TRUE, 'Chambre Deluxe avec vue panoramique'),
('401', 'SUITE', 350.00, 4, TRUE, 'Suite présidentielle avec jacuzzi');

-- Clients
INSERT INTO clients (nom, prenom, email, telephone, adresse, cin) VALUES
('Trabelsi', 'Ahmed', 'ahmed.t@gmail.com', '55123456', 'Tunis, Tunisie', '12345678'),
('Ferjani', 'Leila', 'leila.f@gmail.com', '22987654', 'Sfax, Tunisie', '87654321'),
('Bensalah', 'Omar', 'omar.b@gmail.com', '99111222', 'Sousse, Tunisie', '11223344');

-- Réservations
INSERT INTO reservations (client_id, chambre_id, utilisateur_id, date_arrivee, date_depart, statut, montant_total, notes) VALUES
(1, 3, 2, '2026-05-01', '2026-05-05', 'CONFIRMEE', 520.00, 'Client VIP'),
(2, 1, 2, '2026-05-10', '2026-05-12', 'EN_ATTENTE', 160.00, ''),
(3, 6, 1, '2026-05-15', '2026-05-20', 'CONFIRMEE', 1750.00, 'Suite présidentielle');
