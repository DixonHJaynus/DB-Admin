CREATE TABLE IF NOT EXISTS `dbadmin_reports` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `reporter_id` VARCHAR(60) NOT NULL,
    `reporter_name` VARCHAR(100) NOT NULL,
    `reporter_charname` VARCHAR(100) DEFAULT NULL,
    `category` ENUM('bug', 'player', 'question') NOT NULL DEFAULT 'bug',
    `title` VARCHAR(255) NOT NULL,
    `message` TEXT NOT NULL,
    `status` ENUM('open', 'claimed', 'resolved', 'closed') NOT NULL DEFAULT 'open',
    `claimed_by` VARCHAR(100) DEFAULT NULL,
    `claimed_by_id` VARCHAR(60) DEFAULT NULL,
    `nearby_players` TEXT DEFAULT NULL,
    `coords` VARCHAR(100) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `resolved_at` TIMESTAMP NULL DEFAULT NULL,
    INDEX `idx_status` (`status`),
    INDEX `idx_reporter` (`reporter_id`),
    INDEX `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `dbadmin_report_notes` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `report_id` INT NOT NULL,
    `author_name` VARCHAR(100) NOT NULL,
    `author_id` VARCHAR(60) NOT NULL,
    `note` TEXT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`report_id`) REFERENCES `dbadmin_reports`(`id`) ON DELETE CASCADE,
    INDEX `idx_report` (`report_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `dbadmin_bans` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `banned_id` VARCHAR(60) NOT NULL,
    `banned_name` VARCHAR(100) NOT NULL,
    `banned_by` VARCHAR(100) NOT NULL,
    `banned_by_id` VARCHAR(60) NOT NULL,
    `reason` TEXT NOT NULL,
    `permanent` TINYINT(1) NOT NULL DEFAULT 0,
    `expires_at` TIMESTAMP NULL DEFAULT NULL,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `unbanned_by` VARCHAR(100) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_banned` (`banned_id`),
    INDEX `idx_active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `dbadmin_logs` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `admin_id` VARCHAR(60) NOT NULL,
    `admin_name` VARCHAR(100) NOT NULL,
    `action` VARCHAR(100) NOT NULL,
    `target_id` VARCHAR(60) DEFAULT NULL,
    `target_name` VARCHAR(100) DEFAULT NULL,
    `details` TEXT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_admin` (`admin_id`),
    INDEX `idx_action` (`action`),
    INDEX `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `dbadmin_announcements` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `admin_id` VARCHAR(60) NOT NULL,
    `admin_name` VARCHAR(100) NOT NULL,
    `type` VARCHAR(20) NOT NULL DEFAULT 'info',
    `message` TEXT NOT NULL,
    `target` VARCHAR(60) DEFAULT 'all' COMMENT 'all or specific player id',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `dbadmin_permissions` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(60) NOT NULL,
    `player_name` VARCHAR(100) NOT NULL,
    `permission_type` ENUM('group', 'ace') NOT NULL DEFAULT 'ace',
    `permission` VARCHAR(100) NOT NULL,
    `granted_by` VARCHAR(100) NOT NULL,
    `granted_by_id` VARCHAR(60) NOT NULL,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `revoked_by` VARCHAR(100) DEFAULT NULL,
    `revoked_at` TIMESTAMP NULL DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_identifier` (`identifier`),
    INDEX `idx_active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
