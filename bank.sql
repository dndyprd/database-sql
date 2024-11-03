-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Waktu pembuatan: 05 Mar 2024 pada 10.37
-- Versi server: 5.7.34
-- Versi PHP: 8.2.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bank`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `alamatNasabah` (`alamatNsbh` VARCHAR(85))   BEGIN
SELECT *
FROM nasabah
WHERE alamat = alamatNsbh;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `dataNasabah` (IN `noRekeningNsbh` VARCHAR(20))   BEGIN
    SELECT nasabah.*, transaksi.totalSaldo
    FROM nasabah
    LEFT JOIN transaksi ON nasabah.noRekening = transaksi.noRekening
    WHERE nasabah.noRekening = noRekeningNsbh;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `informasiNasabah`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `informasiNasabah` (
`noRekening` varchar(20)
,`nama` varchar(100)
,`alamat` varchar(50)
,`jenisKelamin` enum('Laki-Laki','Perempuan')
,`noTelp` varchar(20)
,`tglLahir` date
,`totalSaldo` int(50)
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `nasabah`
--

CREATE TABLE `nasabah` (
  `noRekening` varchar(20) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `alamat` varchar(50) NOT NULL,
  `jenisKelamin` enum('Laki-Laki','Perempuan') NOT NULL,
  `noTelp` varchar(20) NOT NULL,
  `tglLahir` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `nasabah`
--

INSERT INTO `nasabah` (`noRekening`, `nama`, `alamat`, `jenisKelamin`, `noTelp`, `tglLahir`) VALUES
('5100101001', 'Taylor', 'Buleleng', 'Perempuan', '082132334465', '2006-01-01'),
('5100102006', 'Dandy', 'Badung', 'Laki-Laki', '082122334455', '2006-02-01'),
('5100103006', 'Eka', 'Denpasar', 'Laki-Laki', '082112334445', '2006-03-01'),
('5100104006', 'Dariel', 'Badung', 'Laki-Laki', '081223445526', '2006-04-01'),
('5100105006', 'Rosa', 'Badung', 'Perempuan', '082122233456', '2006-05-01'),
('5100106006', 'Kirana', 'Denpasar', 'Perempuan', '081213345526', '2006-06-01'),
('5100107006', 'Chitta', 'Denpasar', 'Perempuan', '082123334556', '2006-07-01'),
('5100111006', 'Adi', 'Buleleng', 'Laki-Laki', '082115334446', '2006-11-01');

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `nasabahPrioritas`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `nasabahPrioritas` (
`noRekening` varchar(20)
,`nama` varchar(100)
,`alamat` varchar(50)
,`jenisKelamin` enum('Laki-Laki','Perempuan')
,`noTelp` varchar(20)
,`tglLahir` date
,`totalSaldo` int(50)
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `setor`
--

CREATE TABLE `setor` (
  `tglSetor` date NOT NULL,
  `noRekening` varchar(20) NOT NULL,
  `transaksi` int(50) NOT NULL,
  `idTeller` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `setor`
--

INSERT INTO `setor` (`tglSetor`, `noRekening`, `transaksi`, `idTeller`) VALUES
('2024-03-03', '5100102006', 25000000, 'T01'),
('2024-03-03', '5100105006', 1500000, 'T01'),
('2024-03-03', '5100103006', 45000000, 'T02'),
('2024-03-03', '5100102006', 1750000, 'T01'),
('2024-03-03', '5100106006', 550000, 'T03'),
('2024-03-04', '5100102006', 15000000, 'T02'),
('2024-03-04', '5100103006', 47500000, 'T02'),
('2024-03-04', '5100111006', 15000000, 'T03'),
('2024-03-04', '5100101006', 375500000, 'T03'),
('2024-03-04', '5100107006', 14500000, 'T01'),
('2024-03-05', '5100102006', 52500000, 'T02'),
('2024-03-05', '5100102006', 37500000, 'T01'),
('2024-03-05', '5100107006', 27500000, 'T01'),
('2024-03-05', '5100103006', 10000000, 'T01'),
('2024-03-06', '5100102006', 22500000, 'T02'),
('2024-03-06', '5100106006', 2500000, 'T03');

--
-- Trigger `setor`
--
DELIMITER $$
CREATE TRIGGER `tambahSaldo` AFTER INSERT ON `setor` FOR EACH ROW BEGIN
    DECLARE total_saldo INT;
    
    SELECT totalSaldo INTO total_saldo
    FROM transaksi
    WHERE noRekening = NEW.noRekening;
    
    IF total_saldo IS NOT NULL THEN
        UPDATE transaksi
        SET totalSaldo = totalSaldo + NEW.transaksi
        WHERE noRekening = NEW.noRekening;
    ELSE
        INSERT INTO transaksi (noRekening, totalSaldo)
        VALUES (NEW.noRekening, NEW.transaksi);
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `tarik`
--

CREATE TABLE `tarik` (
  `tglTarik` date NOT NULL,
  `noRekening` varchar(20) NOT NULL,
  `transaksi` int(50) NOT NULL,
  `idTeller` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `tarik`
--

INSERT INTO `tarik` (`tglTarik`, `noRekening`, `transaksi`, `idTeller`) VALUES
('2024-03-05', '5100106006', 1500000, 'T02'),
('2024-03-05', '5100101006', 57525000, 'T01'),
('2024-03-06', '5100103006', 15000000, 'T01'),
('2024-03-06', '5100107006', 525000, 'T01');

--
-- Trigger `tarik`
--
DELIMITER $$
CREATE TRIGGER `kurangSaldo` AFTER INSERT ON `tarik` FOR EACH ROW BEGIN

    UPDATE transaksi

    SET totalSaldo = totalSaldo - NEW.transaksi

    WHERE noRekening = NEW.noRekening;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `teller`
--

CREATE TABLE `teller` (
  `id` varchar(5) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `noTelp` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `teller`
--

INSERT INTO `teller` (`id`, `nama`, `noTelp`) VALUES
('T01', 'Lisa Blackpink', '08312456879'),
('T02', 'Tom Holland', '0832143928779'),
('T03', 'Selena Gomez', '085159777338');

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaksi`
--

CREATE TABLE `transaksi` (
  `noRekening` varchar(50) NOT NULL,
  `totalSaldo` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `transaksi`
--

INSERT INTO `transaksi` (`noRekening`, `totalSaldo`) VALUES
('5100102006', 92500000),
('5100105006', 1500000),
('5100103006', 87500000),
('5100102006', 61750000),
('5100106006', 1550000),
('5100111006', 15000000),
('5100101006', 317975000),
('5100107006', 41475000);

-- --------------------------------------------------------

--
-- Struktur untuk view `informasiNasabah`
--
DROP TABLE IF EXISTS `informasiNasabah`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `informasiNasabah`  AS SELECT `nasabah`.`noRekening` AS `noRekening`, `nasabah`.`nama` AS `nama`, `nasabah`.`alamat` AS `alamat`, `nasabah`.`jenisKelamin` AS `jenisKelamin`, `nasabah`.`noTelp` AS `noTelp`, `nasabah`.`tglLahir` AS `tglLahir`, `transaksi`.`totalSaldo` AS `totalSaldo` FROM (`nasabah` left join `transaksi` on((`nasabah`.`noRekening` = `transaksi`.`noRekening`))) ;

-- --------------------------------------------------------

--
-- Struktur untuk view `nasabahPrioritas`
--
DROP TABLE IF EXISTS `nasabahPrioritas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `nasabahPrioritas`  AS SELECT `n`.`noRekening` AS `noRekening`, `n`.`nama` AS `nama`, `n`.`alamat` AS `alamat`, `n`.`jenisKelamin` AS `jenisKelamin`, `n`.`noTelp` AS `noTelp`, `n`.`tglLahir` AS `tglLahir`, `t`.`totalSaldo` AS `totalSaldo` FROM (`nasabah` `n` left join `transaksi` `t` on((`n`.`noRekening` = `t`.`noRekening`))) WHERE (`t`.`totalSaldo` >= 50000000) ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `nasabah`
--
ALTER TABLE `nasabah`
  ADD PRIMARY KEY (`noRekening`);

--
-- Indeks untuk tabel `setor`
--
ALTER TABLE `setor`
  ADD KEY `noRekening` (`noRekening`),
  ADD KEY `idTeller` (`idTeller`);

--
-- Indeks untuk tabel `tarik`
--
ALTER TABLE `tarik`
  ADD KEY `noRekening` (`noRekening`),
  ADD KEY `idTeller` (`idTeller`);

--
-- Indeks untuk tabel `teller`
--
ALTER TABLE `teller`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD KEY `noRekening` (`noRekening`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
