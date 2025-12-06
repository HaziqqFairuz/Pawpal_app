-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Dec 06, 2025 at 10:10 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pawpal_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pets`
--

CREATE TABLE `tbl_pets` (
  `pet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_name` varchar(100) NOT NULL,
  `pet_type` varchar(50) NOT NULL,
  `category` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `image_paths` text NOT NULL,
  `lat` varchar(50) NOT NULL,
  `lng` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_pets`
--

INSERT INTO `tbl_pets` (`pet_id`, `user_id`, `pet_name`, `pet_type`, `category`, `description`, `image_paths`, `lat`, `lng`, `created_at`) VALUES
(26, 3, 'KOKO', 'Cat', 'Adoption', 'Have yellow eyes and cute face', '[\"assets/pets/pet_26_0.png\",\"assets/pets/pet_26_1.png\",\"assets/pets/pet_26_2.png\"]', '37.4219983', '-122.084', '2025-12-06 08:32:55'),
(27, 3, 'PUPPY', 'Dog', 'Help/Rescue', 'PUPPY is missing, with dark brown color, last seen at behind home', '[\"assets/pets/pet_27_0.png\"]', '37.4219983', '-122.084', '2025-12-06 08:46:43'),
(28, 3, 'LILY', 'Rabbit', 'Donation Request', 'LILY need some fund to their operation', '[\"assets/pets/pet_28_0.png\"]', '37.4219983', '-122.084', '2025-12-06 08:47:22');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(5) NOT NULL,
  `email` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `password` varchar(225) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `reg_date` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `email`, `name`, `password`, `phone`, `reg_date`) VALUES
(3, 'haziqfairuz02157@gmail.com', 'Muhammad Haziq', 'f7c3bc1d808e04732adf679965ccc34ca7ae3441', '0122203908', '2025-11-25 18:12:31.791278'),
(4, 'amirul@gmail.com', 'amirul naj', 'bc3fa85725faafb899d3cd087484ecd09d05d8ce', '0125437889', '2025-11-25 18:43:39.063040'),
(5, 'zulfiqar.hawari@gmail.com', 'ZULFIQAR BIN HAWARI', 'bac9da127e393946a2f7a3c68712e3276a26a81b', '01158976208', '2025-11-25 18:48:27.463834'),
(6, 'megat@gmail.com', 'Megat Irfan', '7c4a8d09ca3762af61e59520943dc26494f8941b', '0122203908', '2025-11-25 23:18:52.759408');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  ADD UNIQUE KEY `pet_id` (`pet_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  MODIFY `pet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
