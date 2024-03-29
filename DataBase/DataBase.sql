USE [master]
GO
/****** Object:  Database [Work]    Script Date: 22.09.2022 16:58:48 ******/
CREATE DATABASE [Work]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Work', FILENAME = N'E:\Work_DB\Work.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Work_log', FILENAME = N'E:\Work_DB\Work_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Work] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Work].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Work] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Work] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Work] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Work] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Work] SET ARITHABORT OFF 
GO
ALTER DATABASE [Work] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Work] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Work] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Work] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Work] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Work] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Work] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Work] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Work] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Work] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Work] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Work] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Work] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Work] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Work] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Work] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Work] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Work] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Work] SET  MULTI_USER 
GO
ALTER DATABASE [Work] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Work] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Work] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Work] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Work] SET DELAYED_DURABILITY = DISABLED 
GO
USE [Work]
GO
/****** Object:  Table [dbo].[Бухгалтер]    Script Date: 22.09.2022 16:58:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Бухгалтер](
	[Код_бухгалтера] [int] IDENTITY(1,1) NOT NULL,
	[Логин] [varchar](50) NOT NULL,
	[Пароль] [varchar](50) NOT NULL,
	[Роль] [varchar](30) NOT NULL,
 CONSTRAINT [PK_Бухгалтер] PRIMARY KEY CLUSTERED 
(
	[Код_бухгалтера] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Выплаты]    Script Date: 22.09.2022 16:58:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Выплаты](
	[Номер_выплаты] [int] IDENTITY(1,1) NOT NULL,
	[Код_работника] [int] NOT NULL,
	[Оклад] [money] NOT NULL CONSTRAINT [DF_Выплаты_Оклад]  DEFAULT ((13890)),
	[Стим_выплаты] [money] NULL CONSTRAINT [DF_Выплаты_Стим_выплаты]  DEFAULT ((0)),
	[Ком_выплаты] [money] NULL CONSTRAINT [DF_Выплаты_Ком_выплаты]  DEFAULT ((0)),
	[Доплаты] [money] NULL CONSTRAINT [DF_Выплаты_Доплаты]  DEFAULT ((0)),
	[Прочие_выплаты] [money] NULL CONSTRAINT [DF_Выплаты_Прочие_выплаты]  DEFAULT ((0)),
	[Р_коэф] [decimal](3, 2) NULL CONSTRAINT [DF_Выплаты_Р_коэф]  DEFAULT ((1)),
	[Начислено]  AS ((((([Оклад]+[Стим_выплаты])+[Ком_выплаты])+[Доплаты])+[Прочие_выплаты])*[Р_коэф]),
 CONSTRAINT [PK_Выплаты_1] PRIMARY KEY CLUSTERED 
(
	[Номер_выплаты] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[История_заработной_платы]    Script Date: 22.09.2022 16:58:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[История_заработной_платы](
	[Код_истории_зп] [int] IDENTITY(1,1) NOT NULL,
	[Номер_выплаты] [int] NOT NULL,
	[Код_работника] [int] NOT NULL,
	[Код_бухгалтера] [int] NOT NULL,
	[Начислено] [money] NOT NULL CONSTRAINT [DF_История_заработной_платы_Начислено]  DEFAULT ((13890)),
	[Вычет_на_детей] [money] NULL CONSTRAINT [DF_История_заработной_платы_Вычет_на_детей]  DEFAULT ((0)),
	[НДФЛ]  AS ((([Начислено]-[Вычет_на_детей])*(13))/(100)),
	[Итоговая_зп]  AS ([Начислено]-(([Начислено]-[Вычет_на_детей])*(13))/(100)),
 CONSTRAINT [PK_История_заработной_платы_1] PRIMARY KEY CLUSTERED 
(
	[Код_истории_зп] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Отчисления]    Script Date: 22.09.2022 16:58:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Отчисления](
	[Номер_отчисления] [int] IDENTITY(1,1) NOT NULL,
	[Код_работника] [int] NOT NULL,
	[Номер_выплаты] [int] NOT NULL,
	[Начислено] [money] NOT NULL CONSTRAINT [DF_Отчисления_Сумма_до_отчисл]  DEFAULT ((13890)),
	[Мед_отчисл]  AS (([Начислено]*(5.1))/(100)),
	[Соц_отчисл]  AS (([Начислено]*(2.9))/(100)),
	[Пенс_отчисл]  AS (([Начислено]*(22))/(100)),
	[ФСС_отчисл]  AS (([Начислено]*(0.2))/(100)),
 CONSTRAINT [PK_Отчисления] PRIMARY KEY CLUSTERED 
(
	[Номер_отчисления] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Работник]    Script Date: 22.09.2022 16:58:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Работник](
	[Код_работника] [int] IDENTITY(1,1) NOT NULL,
	[Фамилия] [nvarchar](30) NULL,
	[Имя] [nvarchar](30) NOT NULL,
	[Отчество] [nvarchar](30) NOT NULL,
	[Дата_трудоустройства] [smalldatetime] NOT NULL,
	[Должность] [nvarchar](30) NOT NULL,
	[Пол] [nvarchar](10) NOT NULL,
	[Семейное_положение] [nvarchar](15) NOT NULL,
	[Дети] [nvarchar](10) NOT NULL,
	[Кол_детей] [int] NULL CONSTRAINT [DF_Работник_Кол_детей]  DEFAULT ((0)),
 CONSTRAINT [PK_Работник] PRIMARY KEY CLUSTERED 
(
	[Код_работника] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Счет]    Script Date: 22.09.2022 16:58:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Счет](
	[Номер_счета] [int] IDENTITY(1,1) NOT NULL,
	[Код_работника] [int] NOT NULL,
	[Номер_карты] [bigint] NOT NULL,
	[Срок_действия] [smalldatetime] NOT NULL,
	[Проверочный_код] [char](3) NOT NULL,
 CONSTRAINT [PK_Счет_1] PRIMARY KEY CLUSTERED 
(
	[Номер_счета] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Бухгалтер] ON 

INSERT [dbo].[Бухгалтер] ([Код_бухгалтера], [Логин], [Пароль], [Роль]) VALUES (15, N'admin', N'21232F297A57A5A743894A0E4A801FC3', N'Главный бухгалтер')
INSERT [dbo].[Бухгалтер] ([Код_бухгалтера], [Логин], [Пароль], [Роль]) VALUES (17, N'polina', N'827CCB0EEA8A706C4C34A16891F84E7B', N'Бухгалтер')
INSERT [dbo].[Бухгалтер] ([Код_бухгалтера], [Логин], [Пароль], [Роль]) VALUES (21, N'Мороз', N'03E73BE4823AAE1BC25FA91BBBE86019', N'Бухгалтер')
INSERT [dbo].[Бухгалтер] ([Код_бухгалтера], [Логин], [Пароль], [Роль]) VALUES (29, N'Petr1', N'F5BB0C8DE146C67B44BABBF4E6584CC0', N'Бухгалтер')
INSERT [dbo].[Бухгалтер] ([Код_бухгалтера], [Логин], [Пароль], [Роль]) VALUES (30, N'Кекс', N'E94F0BFAB8C987A7437BA4E1697C1CC0', N'Бухгалтер')
SET IDENTITY_INSERT [dbo].[Бухгалтер] OFF
SET IDENTITY_INSERT [dbo].[Выплаты] ON 

INSERT [dbo].[Выплаты] ([Номер_выплаты], [Код_работника], [Оклад], [Стим_выплаты], [Ком_выплаты], [Доплаты], [Прочие_выплаты], [Р_коэф]) VALUES (19, 3, 18539.0000, 0.0000, 0.0000, 0.0000, 5000.0000, CAST(1.82 AS Decimal(3, 2)))
INSERT [dbo].[Выплаты] ([Номер_выплаты], [Код_работника], [Оклад], [Стим_выплаты], [Ком_выплаты], [Доплаты], [Прочие_выплаты], [Р_коэф]) VALUES (20, 6, 18269.0000, 16984.0000, 0.0000, 0.0000, 1500.0000, CAST(1.00 AS Decimal(3, 2)))
INSERT [dbo].[Выплаты] ([Номер_выплаты], [Код_работника], [Оклад], [Стим_выплаты], [Ком_выплаты], [Доплаты], [Прочие_выплаты], [Р_коэф]) VALUES (21, 4, 893695555.0000, 0.0000, 444444444.0000, 444444444.0000, 444444444.0000, CAST(1.00 AS Decimal(3, 2)))
INSERT [dbo].[Выплаты] ([Номер_выплаты], [Код_работника], [Оклад], [Стим_выплаты], [Ком_выплаты], [Доплаты], [Прочие_выплаты], [Р_коэф]) VALUES (22, 9, 89632.0000, 15963.0000, 0.0000, 5230.0000, 0.0000, CAST(1.00 AS Decimal(3, 2)))
INSERT [dbo].[Выплаты] ([Номер_выплаты], [Код_работника], [Оклад], [Стим_выплаты], [Ком_выплаты], [Доплаты], [Прочие_выплаты], [Р_коэф]) VALUES (23, 12, 213123123.0000, 123123123.0000, 9999999.0000, 9909.0000, 10102.0000, CAST(1.20 AS Decimal(3, 2)))
SET IDENTITY_INSERT [dbo].[Выплаты] OFF
SET IDENTITY_INSERT [dbo].[История_заработной_платы] ON 

INSERT [dbo].[История_заработной_платы] ([Код_истории_зп], [Номер_выплаты], [Код_работника], [Код_бухгалтера], [Начислено], [Вычет_на_детей]) VALUES (8, 19, 3, 21, 42840.9800, 5000.0000)
INSERT [dbo].[История_заработной_платы] ([Код_истории_зп], [Номер_выплаты], [Код_работника], [Код_бухгалтера], [Начислено], [Вычет_на_детей]) VALUES (9, 20, 6, 17, 36753.0000, 0.0000)
INSERT [dbo].[История_заработной_платы] ([Код_истории_зп], [Номер_выплаты], [Код_работника], [Код_бухгалтера], [Начислено], [Вычет_на_детей]) VALUES (10, 21, 4, 15, 2227028887.0000, 5800.0000)
SET IDENTITY_INSERT [dbo].[История_заработной_платы] OFF
SET IDENTITY_INSERT [dbo].[Отчисления] ON 

INSERT [dbo].[Отчисления] ([Номер_отчисления], [Код_работника], [Номер_выплаты], [Начислено]) VALUES (13, 4, 21, 2227028887.0000)
INSERT [dbo].[Отчисления] ([Номер_отчисления], [Код_работника], [Номер_выплаты], [Начислено]) VALUES (14, 3, 19, 42840.9800)
INSERT [dbo].[Отчисления] ([Номер_отчисления], [Код_работника], [Номер_выплаты], [Начислено]) VALUES (15, 6, 20, 36753.0000)
SET IDENTITY_INSERT [dbo].[Отчисления] OFF
SET IDENTITY_INSERT [dbo].[Работник] ON 

INSERT [dbo].[Работник] ([Код_работника], [Фамилия], [Имя], [Отчество], [Дата_трудоустройства], [Должность], [Пол], [Семейное_положение], [Дети], [Кол_детей]) VALUES (3, N'Лан-Дан-Ди', N'Гертруда', N'Николаевна', CAST(N'2019-03-01 00:00:00' AS SmallDateTime), N'Графический дизайнер', N'женский', N'не замужем', N'нет', 0)
INSERT [dbo].[Работник] ([Код_работника], [Фамилия], [Имя], [Отчество], [Дата_трудоустройства], [Должность], [Пол], [Семейное_положение], [Дети], [Кол_детей]) VALUES (4, N'Морозов', N'Илья', N'Алексеевич', CAST(N'2018-05-01 00:00:00' AS SmallDateTime), N'Дизайнер', N'мужской', N'женат', N'есть', 3)
INSERT [dbo].[Работник] ([Код_работника], [Фамилия], [Имя], [Отчество], [Дата_трудоустройства], [Должность], [Пол], [Семейное_положение], [Дети], [Кол_детей]) VALUES (6, N'Кутузов', N'Аркадий', N'Андреевич', CAST(N'2018-01-01 00:00:00' AS SmallDateTime), N'Системный администратор', N'мужской', N'холост', N'нет', 0)
INSERT [dbo].[Работник] ([Код_работника], [Фамилия], [Имя], [Отчество], [Дата_трудоустройства], [Должность], [Пол], [Семейное_положение], [Дети], [Кол_детей]) VALUES (8, N'Морозова', N'Анастасия', N'Андреевна', CAST(N'2022-03-01 00:00:00' AS SmallDateTime), N' Повар', N'женский', N'замужем', N'есть', 1)
INSERT [dbo].[Работник] ([Код_работника], [Фамилия], [Имя], [Отчество], [Дата_трудоустройства], [Должность], [Пол], [Семейное_положение], [Дети], [Кол_детей]) VALUES (9, N'Белогривцев', N'Андрей', N'', CAST(N'2016-03-01 00:00:00' AS SmallDateTime), N'Патриарх', N'мужской', N'женат', N'есть', 5)
INSERT [dbo].[Работник] ([Код_работника], [Фамилия], [Имя], [Отчество], [Дата_трудоустройства], [Должность], [Пол], [Семейное_положение], [Дети], [Кол_детей]) VALUES (11, N'Алексеева', N'Алина', N'Антоновна', CAST(N'2021-07-01 00:00:00' AS SmallDateTime), N'Руководитель 2-го отдела', N'женский', N'замужем', N'нет', 0)
INSERT [dbo].[Работник] ([Код_работника], [Фамилия], [Имя], [Отчество], [Дата_трудоустройства], [Должность], [Пол], [Семейное_положение], [Дети], [Кол_детей]) VALUES (12, N'фвы', N'фывфы', N'ывыаыв', CAST(N'1988-09-01 00:00:00' AS SmallDateTime), N'фывлыоиавыта', N'мужской', N'холост', N'нет', 0)
INSERT [dbo].[Работник] ([Код_работника], [Фамилия], [Имя], [Отчество], [Дата_трудоустройства], [Должность], [Пол], [Семейное_положение], [Дети], [Кол_детей]) VALUES (13, N'fghjkp', N'fghjklp', N'', CAST(N'2022-06-01 00:00:00' AS SmallDateTime), N'ghjkl', N'женский', N'не замужем', N'нет', 0)
SET IDENTITY_INSERT [dbo].[Работник] OFF
SET IDENTITY_INSERT [dbo].[Счет] ON 

INSERT [dbo].[Счет] ([Номер_счета], [Код_работника], [Номер_карты], [Срок_действия], [Проверочный_код]) VALUES (27, 11, 6532659852659865, CAST(N'2023-08-01 00:00:00' AS SmallDateTime), N'699')
INSERT [dbo].[Счет] ([Номер_счета], [Код_работника], [Номер_карты], [Срок_действия], [Проверочный_код]) VALUES (32, 9, 1545464654667885, CAST(N'2028-02-01 00:00:00' AS SmallDateTime), N'125')
INSERT [dbo].[Счет] ([Номер_счета], [Код_работника], [Номер_карты], [Срок_действия], [Проверочный_код]) VALUES (38, 3, 5963145216589452, CAST(N'2022-12-01 00:00:00' AS SmallDateTime), N'111')
INSERT [dbo].[Счет] ([Номер_счета], [Код_работника], [Номер_карты], [Срок_действия], [Проверочный_код]) VALUES (39, 4, 8451208465120845, CAST(N'2023-01-04 00:00:00' AS SmallDateTime), N'569')
INSERT [dbo].[Счет] ([Номер_счета], [Код_работника], [Номер_карты], [Срок_действия], [Проверочный_код]) VALUES (40, 8, 8641235984125597, CAST(N'2023-07-01 00:00:00' AS SmallDateTime), N'396')
SET IDENTITY_INSERT [dbo].[Счет] OFF
ALTER TABLE [dbo].[Выплаты]  WITH CHECK ADD  CONSTRAINT [FK_Выплаты_Работник] FOREIGN KEY([Код_работника])
REFERENCES [dbo].[Работник] ([Код_работника])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Выплаты] CHECK CONSTRAINT [FK_Выплаты_Работник]
GO
ALTER TABLE [dbo].[История_заработной_платы]  WITH CHECK ADD  CONSTRAINT [FK_История_заработной_платы_Бухгалтер] FOREIGN KEY([Код_бухгалтера])
REFERENCES [dbo].[Бухгалтер] ([Код_бухгалтера])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[История_заработной_платы] CHECK CONSTRAINT [FK_История_заработной_платы_Бухгалтер]
GO
ALTER TABLE [dbo].[История_заработной_платы]  WITH CHECK ADD  CONSTRAINT [FK_История_заработной_платы_Выплаты] FOREIGN KEY([Номер_выплаты])
REFERENCES [dbo].[Выплаты] ([Номер_выплаты])
GO
ALTER TABLE [dbo].[История_заработной_платы] CHECK CONSTRAINT [FK_История_заработной_платы_Выплаты]
GO
ALTER TABLE [dbo].[История_заработной_платы]  WITH CHECK ADD  CONSTRAINT [FK_История_заработной_платы_Работник] FOREIGN KEY([Код_работника])
REFERENCES [dbo].[Работник] ([Код_работника])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[История_заработной_платы] CHECK CONSTRAINT [FK_История_заработной_платы_Работник]
GO
ALTER TABLE [dbo].[Отчисления]  WITH CHECK ADD  CONSTRAINT [FK_Отчисления_Работник] FOREIGN KEY([Код_работника])
REFERENCES [dbo].[Работник] ([Код_работника])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Отчисления] CHECK CONSTRAINT [FK_Отчисления_Работник]
GO
ALTER TABLE [dbo].[Счет]  WITH CHECK ADD  CONSTRAINT [FK_Счет_Код_работника] FOREIGN KEY([Код_работника])
REFERENCES [dbo].[Работник] ([Код_работника])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Счет] CHECK CONSTRAINT [FK_Счет_Код_работника]
GO
ALTER TABLE [dbo].[Бухгалтер]  WITH CHECK ADD  CONSTRAINT [CK_Бухгалтер] CHECK  (([Роль]='Бухгалтер' OR [Роль]='Главный бухгалтер'))
GO
ALTER TABLE [dbo].[Бухгалтер] CHECK CONSTRAINT [CK_Бухгалтер]
GO
ALTER TABLE [dbo].[Выплаты]  WITH CHECK ADD  CONSTRAINT [CK_Выплаты_Доплаты] CHECK  (([Доплаты]>=(0)))
GO
ALTER TABLE [dbo].[Выплаты] CHECK CONSTRAINT [CK_Выплаты_Доплаты]
GO
ALTER TABLE [dbo].[Выплаты]  WITH CHECK ADD  CONSTRAINT [CK_Выплаты_Ком_выплаты] CHECK  (([Ком_выплаты]>=(0)))
GO
ALTER TABLE [dbo].[Выплаты] CHECK CONSTRAINT [CK_Выплаты_Ком_выплаты]
GO
ALTER TABLE [dbo].[Выплаты]  WITH CHECK ADD  CONSTRAINT [CK_Выплаты_Оклад] CHECK  (([Оклад]>=(13890)))
GO
ALTER TABLE [dbo].[Выплаты] CHECK CONSTRAINT [CK_Выплаты_Оклад]
GO
ALTER TABLE [dbo].[Выплаты]  WITH CHECK ADD  CONSTRAINT [CK_Выплаты_Прочие_выплаты] CHECK  (([Прочие_выплаты]>=(0)))
GO
ALTER TABLE [dbo].[Выплаты] CHECK CONSTRAINT [CK_Выплаты_Прочие_выплаты]
GO
ALTER TABLE [dbo].[Выплаты]  WITH CHECK ADD  CONSTRAINT [CK_Выплаты_Р_коэф] CHECK  (([Р_коэф]>=(1) AND [Р_коэф]<=(2)))
GO
ALTER TABLE [dbo].[Выплаты] CHECK CONSTRAINT [CK_Выплаты_Р_коэф]
GO
ALTER TABLE [dbo].[Выплаты]  WITH CHECK ADD  CONSTRAINT [CK_Выплаты_Стим_выплаты] CHECK  (([Стим_выплаты]>=(0)))
GO
ALTER TABLE [dbo].[Выплаты] CHECK CONSTRAINT [CK_Выплаты_Стим_выплаты]
GO
ALTER TABLE [dbo].[История_заработной_платы]  WITH CHECK ADD  CONSTRAINT [CK_История_заработной_платы_Вычет_на_детей] CHECK  (([Вычет_на_детей]>=(0)))
GO
ALTER TABLE [dbo].[История_заработной_платы] CHECK CONSTRAINT [CK_История_заработной_платы_Вычет_на_детей]
GO
ALTER TABLE [dbo].[История_заработной_платы]  WITH CHECK ADD  CONSTRAINT [CK_История_заработной_платы_Начислено] CHECK  (([Начислено]>=(13890)))
GO
ALTER TABLE [dbo].[История_заработной_платы] CHECK CONSTRAINT [CK_История_заработной_платы_Начислено]
GO
ALTER TABLE [dbo].[Отчисления]  WITH CHECK ADD  CONSTRAINT [CK_Отчисления_Начислено] CHECK  (([Начислено]>=(13890)))
GO
ALTER TABLE [dbo].[Отчисления] CHECK CONSTRAINT [CK_Отчисления_Начислено]
GO
ALTER TABLE [dbo].[Работник]  WITH CHECK ADD  CONSTRAINT [CK_Работник_Дети] CHECK  (([Дети]='нет' OR [Дети]='есть'))
GO
ALTER TABLE [dbo].[Работник] CHECK CONSTRAINT [CK_Работник_Дети]
GO
ALTER TABLE [dbo].[Работник]  WITH CHECK ADD  CONSTRAINT [CK_Работник_Кол_детей] CHECK  (([Кол_детей]>=(0)))
GO
ALTER TABLE [dbo].[Работник] CHECK CONSTRAINT [CK_Работник_Кол_детей]
GO
ALTER TABLE [dbo].[Работник]  WITH CHECK ADD  CONSTRAINT [CK_Работник_Пол] CHECK  (([Пол]='женский' OR [Пол]='мужской'))
GO
ALTER TABLE [dbo].[Работник] CHECK CONSTRAINT [CK_Работник_Пол]
GO
ALTER TABLE [dbo].[Работник]  WITH CHECK ADD  CONSTRAINT [CK_Работник_Семейное_положение] CHECK  (([Семейное_положение]='Не замужем' OR [Семейное_положение]='Холост' OR [Семейное_положение]='Замужем' OR [Семейное_положение]='Женат'))
GO
ALTER TABLE [dbo].[Работник] CHECK CONSTRAINT [CK_Работник_Семейное_положение]
GO
ALTER TABLE [dbo].[Счет]  WITH CHECK ADD  CONSTRAINT [CK_Счет_Номер_карты] CHECK  (([Номер_карты]>=(1000000000000000.) AND [Номер_карты]<=(9999999999999999.)))
GO
ALTER TABLE [dbo].[Счет] CHECK CONSTRAINT [CK_Счет_Номер_карты]
GO
USE [master]
GO
ALTER DATABASE [Work] SET  READ_WRITE 
GO
