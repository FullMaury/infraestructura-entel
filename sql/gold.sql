CREATE SCHEMA GOLD;
GO

CREATE TABLE [GOLD].[dim_numero] (
  [id_numero] int PRIMARY KEY IDENTITY(1, 1),
  [numero] nvarchar(255),
  [imei] nvarchar(255)
)
GO

CREATE TABLE [GOLD].[dim_radio_base] (
  [id_radio_base] int PRIMARY KEY IDENTITY(1, 1),
  [radio_base] nvarchar(255),
  [celda] nvarchar(255),
  [latitud] decimal,
  [longitud] decimal
)
GO

CREATE TABLE [GOLD].[dim_fecha] (
  [id_fecha] int PRIMARY KEY IDENTITY(1, 1),
  [fecha] datetime
)
GO

CREATE TABLE [GOLD].[dim_servicio] (
  [id_servicio] int PRIMARY KEY IDENTITY(1, 1),
  [servicio] nvarchar(255)
)
GO

CREATE TABLE [GOLD].[dim_registro] (
  [id_registro] int PRIMARY KEY IDENTITY(1, 1),
  [registro] nvarchar(255)
)
GO

CREATE TABLE [GOLD].[hechos_datos] (
  [id_datos] int PRIMARY KEY IDENTITY(1, 1),
  [subidos] int,
  [descargador] int,
  [total] int,
  [id_fecha] int,
  [id_numero] int,
  [id_radio_base] int
)
GO

CREATE TABLE [GOLD].[hechos_llamadas] (
  [id_llamadas] int PRIMARY KEY IDENTITY(1, 1),
  [duracion] time,
  [id_servicio] int,
  [id_registro] int,
  [id_numero_a] int,
  [id_radio_base_a] int,
  [id_numero_b] int,
  [id_radio_base_b] int,
  [id_fecha] int
)
GO

ALTER TABLE [GOLD].[hechos_datos] ADD FOREIGN KEY ([id_radio_base]) REFERENCES [GOLD].[dim_radio_base] ([id_radio_base])
GO

ALTER TABLE [GOLD].[hechos_datos] ADD FOREIGN KEY ([id_numero]) REFERENCES [GOLD].[dim_numero] ([id_numero])
GO

ALTER TABLE [GOLD].[hechos_datos] ADD FOREIGN KEY ([id_fecha]) REFERENCES [GOLD].[dim_fecha] ([id_fecha])
GO

ALTER TABLE [GOLD].[hechos_llamadas] ADD FOREIGN KEY ([id_servicio]) REFERENCES [GOLD].[dim_servicio] ([id_servicio])
GO

ALTER TABLE [GOLD].[hechos_llamadas] ADD FOREIGN KEY ([id_registro]) REFERENCES [GOLD].[dim_registro] ([id_registro])
GO

ALTER TABLE [GOLD].[hechos_llamadas] ADD FOREIGN KEY ([id_numero_a]) REFERENCES [GOLD].[dim_numero] ([id_numero])
GO

ALTER TABLE [GOLD].[hechos_llamadas] ADD FOREIGN KEY ([id_numero_b]) REFERENCES [GOLD].[dim_numero] ([id_numero])
GO

ALTER TABLE [GOLD].[hechos_llamadas] ADD FOREIGN KEY ([id_radio_base_a]) REFERENCES [GOLD].[dim_radio_base] ([id_radio_base])
GO

ALTER TABLE [GOLD].[hechos_llamadas] ADD FOREIGN KEY ([id_radio_base_b]) REFERENCES [GOLD].[dim_radio_base] ([id_radio_base])
GO

ALTER TABLE [GOLD].[hechos_llamadas] ADD FOREIGN KEY ([id_fecha]) REFERENCES [GOLD].[dim_fecha] ([id_fecha])
GO
