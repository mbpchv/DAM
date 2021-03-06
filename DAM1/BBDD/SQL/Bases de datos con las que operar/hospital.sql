USE [master]
GO
/****** Object:  Database [hospital]    Script Date: 06/02/2018 19:45:54 ******/
CREATE DATABASE [hospital]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'hospital', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\hospital.mdf' , SIZE = 3328KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'hospital_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\hospital_log.LDF' , SIZE = 3520KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [hospital] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [hospital].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [hospital] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [hospital] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [hospital] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [hospital] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [hospital] SET ARITHABORT OFF 
GO
ALTER DATABASE [hospital] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [hospital] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [hospital] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [hospital] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [hospital] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [hospital] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [hospital] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [hospital] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [hospital] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [hospital] SET  DISABLE_BROKER 
GO
ALTER DATABASE [hospital] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [hospital] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [hospital] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [hospital] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [hospital] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [hospital] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [hospital] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [hospital] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [hospital] SET  MULTI_USER 
GO
ALTER DATABASE [hospital] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [hospital] SET DB_CHAINING OFF 
GO
ALTER DATABASE [hospital] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [hospital] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [hospital] SET DELAYED_DURABILITY = DISABLED 
GO
USE [hospital]
GO
/****** Object:  User [laly_casillas\laly]    Script Date: 06/02/2018 19:45:54 ******/
CREATE USER [laly_casillas\laly] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  UserDefinedFunction [dbo].[eje2013]    Script Date: 06/02/2018 19:45:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[eje2013] (@hospital varchar(15),@sala varchar(15),@cama numeric(3)) returns varchar(40)

begin
declare @hospital_cod int,@sala_cod int,@salida varchar(40)
select @hospital_cod = hospital_cod from hospital where NOMBRE=@hospital
if @hospital_cod is null set @salida='el hospital no existe'
   else
       begin
       select @sala_cod=sala_cod from SALA where HOSPITAL_COD=@hospital_cod and NOMBRE=@sala
       if @sala_cod is null set @salida='esa sala no existe en ese hospital'
          else
              begin
              select @salida=apellido
              from ENFERMO
              where INSCRIPCION in (select INSCRIPCION from OCUPACION
                                    where HOSPITAL_COD=@hospital_cod and SALA_COD=@sala_cod and CAMA=@cama)
              
              if @salida is null set @salida='no hay nadie ingresado'
              end
        end
 return @salida
 end
              
GO
/****** Object:  Table [dbo].[DOCTOR]    Script Date: 06/02/2018 19:45:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DOCTOR](
	[HOSPITAL_COD] [int] NOT NULL,
	[DOCTOR_NO] [int] NOT NULL,
	[APELLIDO] [varchar](10) NULL,
	[ESPECIALIDAD] [varchar](15) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ENFERMO]    Script Date: 06/02/2018 19:45:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ENFERMO](
	[INSCRIPCION] [int] NULL,
	[APELLIDO] [varchar](20) NULL,
	[DIRECCION] [varchar](25) NULL,
	[FECHA_NAC] [smalldatetime] NULL,
	[SEXO] [char](1) NULL,
	[NSS] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HOSPITAL]    Script Date: 06/02/2018 19:45:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HOSPITAL](
	[HOSPITAL_COD] [int] NOT NULL,
	[NOMBRE] [varchar](15) NULL,
	[DIRECCION] [varchar](30) NULL,
	[TELEFONO] [char](8) NULL,
	[NUM_CAMA] [int] NULL,
 CONSTRAINT [pk_hospital_cod] PRIMARY KEY CLUSTERED 
(
	[HOSPITAL_COD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OCUPACION]    Script Date: 06/02/2018 19:45:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OCUPACION](
	[INSCRIPCION] [int] NOT NULL,
	[HOSPITAL_COD] [int] NOT NULL,
	[SALA_COD] [int] NOT NULL,
	[CAMA] [int] NULL,
 CONSTRAINT [pk_inscripcion] PRIMARY KEY CLUSTERED 
(
	[INSCRIPCION] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PLANTILLA]    Script Date: 06/02/2018 19:45:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PLANTILLA](
	[HOSPITAL_COD] [int] NOT NULL,
	[SALA_COD] [int] NOT NULL,
	[EMPLEADO_NO] [int] NULL,
	[APELLIDO] [varchar](15) NULL,
	[FUNCION] [varchar](10) NULL,
	[TURNO] [char](1) NULL,
	[SALARIO] [money] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SALA]    Script Date: 06/02/2018 19:45:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SALA](
	[HOSPITAL_COD] [int] NOT NULL,
	[SALA_COD] [int] NOT NULL,
	[NOMBRE] [varchar](20) NULL,
	[NUM_CAMA] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[DOCTOR] ([HOSPITAL_COD], [DOCTOR_NO], [APELLIDO], [ESPECIALIDAD]) VALUES (13, 435, N'Lopez A.', N'Cardiologia')
INSERT [dbo].[DOCTOR] ([HOSPITAL_COD], [DOCTOR_NO], [APELLIDO], [ESPECIALIDAD]) VALUES (18, 585, N'Miller G.', N'Ginecologia')
INSERT [dbo].[DOCTOR] ([HOSPITAL_COD], [DOCTOR_NO], [APELLIDO], [ESPECIALIDAD]) VALUES (18, 982, N'Cajal R.', N'Cardiologia')
INSERT [dbo].[DOCTOR] ([HOSPITAL_COD], [DOCTOR_NO], [APELLIDO], [ESPECIALIDAD]) VALUES (22, 453, N'Galo D.', N'Pediatria')
INSERT [dbo].[DOCTOR] ([HOSPITAL_COD], [DOCTOR_NO], [APELLIDO], [ESPECIALIDAD]) VALUES (22, 398, N'Best K.', N'Urologia')
INSERT [dbo].[DOCTOR] ([HOSPITAL_COD], [DOCTOR_NO], [APELLIDO], [ESPECIALIDAD]) VALUES (22, 386, N'Cabeza D.', N'Psiquiatria')
INSERT [dbo].[DOCTOR] ([HOSPITAL_COD], [DOCTOR_NO], [APELLIDO], [ESPECIALIDAD]) VALUES (45, 607, N'Nigo P.', N'Pediatria')
INSERT [dbo].[DOCTOR] ([HOSPITAL_COD], [DOCTOR_NO], [APELLIDO], [ESPECIALIDAD]) VALUES (45, 522, N'Adans C.', N'Neurologia')
INSERT [dbo].[ENFERMO] ([INSCRIPCION], [APELLIDO], [DIRECCION], [FECHA_NAC], [SEXO], [NSS]) VALUES (10995, N'Laguia M.', N'Recoletos 50', CAST(N'1997-06-23 00:00:00' AS SmallDateTime), N'M', 280862482)
INSERT [dbo].[ENFERMO] ([INSCRIPCION], [APELLIDO], [DIRECCION], [FECHA_NAC], [SEXO], [NSS]) VALUES (18044, N'Serrano V.', N'Alcala 12', CAST(N'1960-05-21 00:00:00' AS SmallDateTime), N'V', 284991452)
INSERT [dbo].[ENFERMO] ([INSCRIPCION], [APELLIDO], [DIRECCION], [FECHA_NAC], [SEXO], [NSS]) VALUES (14024, N'Fernandez M.', N'Recoletos 50', CAST(N'1967-06-23 00:00:00' AS SmallDateTime), N'V', 321790059)
INSERT [dbo].[ENFERMO] ([INSCRIPCION], [APELLIDO], [DIRECCION], [FECHA_NAC], [SEXO], [NSS]) VALUES (38702, N'Neal R.', N'Orense 11', CAST(N'1940-06-18 00:00:00' AS SmallDateTime), N'V', 380010217)
INSERT [dbo].[ENFERMO] ([INSCRIPCION], [APELLIDO], [DIRECCION], [FECHA_NAC], [SEXO], [NSS]) VALUES (39217, N'Cervantes M.', N'Peron 38', CAST(N'1952-02-29 00:00:00' AS SmallDateTime), N'M', 440294390)
INSERT [dbo].[ENFERMO] ([INSCRIPCION], [APELLIDO], [DIRECCION], [FECHA_NAC], [SEXO], [NSS]) VALUES (59076, N'Miller G.', N'Lopez de Hoyos 2', CAST(N'1945-09-16 00:00:00' AS SmallDateTime), N'V', 311969044)
INSERT [dbo].[ENFERMO] ([INSCRIPCION], [APELLIDO], [DIRECCION], [FECHA_NAC], [SEXO], [NSS]) VALUES (64823, N'Fraser A.', N'Soto 3', CAST(N'1980-07-10 00:00:00' AS SmallDateTime), N'V', 285201776)
INSERT [dbo].[ENFERMO] ([INSCRIPCION], [APELLIDO], [DIRECCION], [FECHA_NAC], [SEXO], [NSS]) VALUES (74835, N'Benitez E.', N'Argentina 5', CAST(N'1957-10-05 00:00:00' AS SmallDateTime), N'M', 154811767)
INSERT [dbo].[ENFERMO] ([INSCRIPCION], [APELLIDO], [DIRECCION], [FECHA_NAC], [SEXO], [NSS]) VALUES (36658, N'Domin S.', N'Mayor 71', CAST(N'1942-01-01 00:00:00' AS SmallDateTime), N'M', 160657471)
INSERT [dbo].[ENFERMO] ([INSCRIPCION], [APELLIDO], [DIRECCION], [FECHA_NAC], [SEXO], [NSS]) VALUES (63827, N'Ruiz P.', N'Ezquerdo 103', CAST(N'1980-12-26 00:00:00' AS SmallDateTime), N'M', 100973253)
INSERT [dbo].[HOSPITAL] ([HOSPITAL_COD], [NOMBRE], [DIRECCION], [TELEFONO], [NUM_CAMA]) VALUES (13, N'Provincial', N'O Donell 50', N'964-4264', 502)
INSERT [dbo].[HOSPITAL] ([HOSPITAL_COD], [NOMBRE], [DIRECCION], [TELEFONO], [NUM_CAMA]) VALUES (18, N'General', N'Atocha s/n', N'595-3111', 987)
INSERT [dbo].[HOSPITAL] ([HOSPITAL_COD], [NOMBRE], [DIRECCION], [TELEFONO], [NUM_CAMA]) VALUES (22, N'La Paz', N'Castellana 1000', N'923-5411', 412)
INSERT [dbo].[HOSPITAL] ([HOSPITAL_COD], [NOMBRE], [DIRECCION], [TELEFONO], [NUM_CAMA]) VALUES (45, N'San Carlos', N'Ciudad Universitaria', N'597-1500', 845)
INSERT [dbo].[OCUPACION] ([INSCRIPCION], [HOSPITAL_COD], [SALA_COD], [CAMA]) VALUES (10995, 13, 3, 1)
INSERT [dbo].[OCUPACION] ([INSCRIPCION], [HOSPITAL_COD], [SALA_COD], [CAMA]) VALUES (14024, 13, 3, 3)
INSERT [dbo].[OCUPACION] ([INSCRIPCION], [HOSPITAL_COD], [SALA_COD], [CAMA]) VALUES (18044, 13, 3, 2)
INSERT [dbo].[OCUPACION] ([INSCRIPCION], [HOSPITAL_COD], [SALA_COD], [CAMA]) VALUES (36658, 18, 4, 1)
INSERT [dbo].[OCUPACION] ([INSCRIPCION], [HOSPITAL_COD], [SALA_COD], [CAMA]) VALUES (38702, 18, 4, 2)
INSERT [dbo].[OCUPACION] ([INSCRIPCION], [HOSPITAL_COD], [SALA_COD], [CAMA]) VALUES (39217, 22, 6, 1)
INSERT [dbo].[OCUPACION] ([INSCRIPCION], [HOSPITAL_COD], [SALA_COD], [CAMA]) VALUES (59076, 22, 6, 2)
INSERT [dbo].[OCUPACION] ([INSCRIPCION], [HOSPITAL_COD], [SALA_COD], [CAMA]) VALUES (63827, 22, 6, 3)
INSERT [dbo].[OCUPACION] ([INSCRIPCION], [HOSPITAL_COD], [SALA_COD], [CAMA]) VALUES (64823, 22, 2, 1)
INSERT [dbo].[PLANTILLA] ([HOSPITAL_COD], [SALA_COD], [EMPLEADO_NO], [APELLIDO], [FUNCION], [TURNO], [SALARIO]) VALUES (13, 6, 3754, N'Diaz B.', N'Enfermera', N'T', 9845.0000)
INSERT [dbo].[PLANTILLA] ([HOSPITAL_COD], [SALA_COD], [EMPLEADO_NO], [APELLIDO], [FUNCION], [TURNO], [SALARIO]) VALUES (13, 6, 3106, N'Hernandez J.', N'Enfermero', N'T', 12050.0000)
INSERT [dbo].[PLANTILLA] ([HOSPITAL_COD], [SALA_COD], [EMPLEADO_NO], [APELLIDO], [FUNCION], [TURNO], [SALARIO]) VALUES (18, 4, 6357, N'Karplus W.', N'Interno', N'T', 9772.0000)
INSERT [dbo].[PLANTILLA] ([HOSPITAL_COD], [SALA_COD], [EMPLEADO_NO], [APELLIDO], [FUNCION], [TURNO], [SALARIO]) VALUES (22, 6, 1009, N'Higueras D', N'Enfermera', N'T', 13595.0000)
INSERT [dbo].[PLANTILLA] ([HOSPITAL_COD], [SALA_COD], [EMPLEADO_NO], [APELLIDO], [FUNCION], [TURNO], [SALARIO]) VALUES (22, 6, 8422, N'Bocina G.', N'Enfermero', N'M', 13282.0000)
INSERT [dbo].[PLANTILLA] ([HOSPITAL_COD], [SALA_COD], [EMPLEADO_NO], [APELLIDO], [FUNCION], [TURNO], [SALARIO]) VALUES (22, 2, 9901, N'Nuñez C.', N'Interno', N'M', 18030.0000)
INSERT [dbo].[PLANTILLA] ([HOSPITAL_COD], [SALA_COD], [EMPLEADO_NO], [APELLIDO], [FUNCION], [TURNO], [SALARIO]) VALUES (22, 1, 6065, N'Rivera G.', N'Enfermera', N'N', 13282.0000)
INSERT [dbo].[PLANTILLA] ([HOSPITAL_COD], [SALA_COD], [EMPLEADO_NO], [APELLIDO], [FUNCION], [TURNO], [SALARIO]) VALUES (22, 1, 7379, N'Carlos R.', N'Enfermera', N'T', 12735.0000)
INSERT [dbo].[PLANTILLA] ([HOSPITAL_COD], [SALA_COD], [EMPLEADO_NO], [APELLIDO], [FUNCION], [TURNO], [SALARIO]) VALUES (45, 4, 1280, N'Amigo R.', N'Interno', N'N', 20308.0000)
INSERT [dbo].[PLANTILLA] ([HOSPITAL_COD], [SALA_COD], [EMPLEADO_NO], [APELLIDO], [FUNCION], [TURNO], [SALARIO]) VALUES (45, 1, 8526, N'Frank H.', N'Enfermera', N'T', 15158.0000)
INSERT [dbo].[PLANTILLA] ([HOSPITAL_COD], [SALA_COD], [EMPLEADO_NO], [APELLIDO], [FUNCION], [TURNO], [SALARIO]) VALUES (22, 2, 1234, N'Garcia J.', N'Enfermero', N'M', 16558.0000)
INSERT [dbo].[SALA] ([HOSPITAL_COD], [SALA_COD], [NOMBRE], [NUM_CAMA]) VALUES (13, 3, N'Cuidados Intensivos', 21)
INSERT [dbo].[SALA] ([HOSPITAL_COD], [SALA_COD], [NOMBRE], [NUM_CAMA]) VALUES (13, 6, N'Psiquiatrico', 67)
INSERT [dbo].[SALA] ([HOSPITAL_COD], [SALA_COD], [NOMBRE], [NUM_CAMA]) VALUES (18, 3, N'Cuidados Intensivos', 10)
INSERT [dbo].[SALA] ([HOSPITAL_COD], [SALA_COD], [NOMBRE], [NUM_CAMA]) VALUES (18, 4, N'Cardiologia', 53)
INSERT [dbo].[SALA] ([HOSPITAL_COD], [SALA_COD], [NOMBRE], [NUM_CAMA]) VALUES (22, 1, N'Recuperacion', 10)
INSERT [dbo].[SALA] ([HOSPITAL_COD], [SALA_COD], [NOMBRE], [NUM_CAMA]) VALUES (22, 6, N'Psiquiatrico', 118)
INSERT [dbo].[SALA] ([HOSPITAL_COD], [SALA_COD], [NOMBRE], [NUM_CAMA]) VALUES (45, 4, N'Cardiologia', 55)
INSERT [dbo].[SALA] ([HOSPITAL_COD], [SALA_COD], [NOMBRE], [NUM_CAMA]) VALUES (45, 1, N'Recuperacion', 13)
INSERT [dbo].[SALA] ([HOSPITAL_COD], [SALA_COD], [NOMBRE], [NUM_CAMA]) VALUES (45, 2, N'Maternidad', 24)
INSERT [dbo].[SALA] ([HOSPITAL_COD], [SALA_COD], [NOMBRE], [NUM_CAMA]) VALUES (22, 2, N'Maternidad', 34)
USE [master]
GO
ALTER DATABASE [hospital] SET  READ_WRITE 
GO
