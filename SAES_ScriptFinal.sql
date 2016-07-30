DROP TABLE HORARIO;
DROP TABLE CLASE;
DROP TABLE RELACION;
DROP TABLE ESTUDIANTE_TELEFONO;
DROP TABLE MAESTRO;
DROP TABLE ESTUDIANTE; 
DROP TABLE MATERIA;
DROP TABLE GRUPO;

/******************************************************************************************************************************/
/******************************************************************************************************************************/
/******************************************************************************************************************************/
/*****************************************************************************************************************************


	M O D E L A D O 


*****************************************************************************************************************************/
/******************************************************************************************************************************/
/******************************************************************************************************************************/
/******************************************************************************************************************************/


CREATE TABLE ESTUDIANTE(

	NumBoleta char(10), --Incluir numero de boleta valido, ej: 2013630567, 2014630201, etc.
	Nombre varchar(100) NOT NULL, --Deben insertarse nombres completos iniciando por el nombre e iniciando la primera letra con mayúsculas, ej: 'Alejandro Rodriguez Ramos'
	Contraseña varchar(30) NOT NULL,
	Semestre int NOT NULL, --Incluir semestre valido 
	FechaIngreso Date NOT NULL, --Deben insertarse de la forma '[AÑO]-[MES]-[DIA]' Ej: '2013-11-30', '2014-05-13'.
	FechaNacim Date NULL,--Deben insertarse de la forma '[AÑO]-[MES]-[DIA]' Ej: '1995-11-30', '1993-05-01'.
	Estado varchar(30) NULL, --Incluir Estado válido
	Municipio varchar(30) NULL,	--Incluir Municipios validos para el estado anterior
	DirExtra varchar(100) NULL, --Incluir Colonia, calle y numero
	Primary Key (NumBoleta)
);
 
CREATE TABLE ESTUDIANTE_TELEFONO(

	NumBoleta char(10), --Insertarse Numeros de Boleta ya ingresados en la tabla ESTUDIANTE
	Telefono varchar(10), --No deben haber telefonos vacios
	Primary Key(NumBoleta, Telefono)
);


ALTER TABLE ESTUDIANTE_TELEFONO ADD CONSTRAINT PK_ESTUDIANTE_TELEFONO FOREIGN KEY(NumBoleta) REFERENCES ESTUDIANTE(NumBoleta);

--------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE GRUPO(

	IdGrupo varchar(5), --Deben insertarse tal como son los grupos reales, ej: '2CM5', '2CV11', '3CM1', etc.
	CicloEscolar char(6), --Deben insertarse de la forma: '2014-1', '2013-2', etc.
	Salon char(4) NOT NULL, --Deben insertarse tal como es la nomenclatura real para salones: '1212', '1006', etc.
	Primary Key (IdGrupo, CicloEscolar)
);

--------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MATERIA(
	 
	IdMateria varchar(5), --Deben insertarse en el formato 'C[Nivel][Dos Digito], ej: C101, C215, C332, etc. 
	Nombre varchar(50) NOT NULL, --Ingresar nombres de materia completos, Ej: 'ANALYSIS AND DESIGN OF PARALLEL ALGORITHMS', 'DISEÑO DE SISTEMAS DIGITALES', etc. 
	Obligatoria bit, --Debe insertarse un 1 si la materia es Obligatoria, 0 si es optativa.
	Primary Key(IdMateria)
);

--------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE MAESTRO(

	IdMAESTRO char(5), --Deben insertarse en el formato '[DIGITO][DIGITO][DIGITO]' Ej: '324','452','234'
	Nombre varchar(50) NOT NULL, --Deben ingresarse nombres completos iniciando por el nombre, primer letra de cada palabra en Mayusculas, ej: Idalia Maldonado Castillo
	Grado varchar(30) --Debe Ingresarse el máximo grado de estudios del MAESTRO, ej: MAESTRIA, DOCTORADO, etc.
	PRIMARY KEY(IdMAESTRO)
);
 
--------------------------------------------------------------------------------------------------------------------------------



--****************************************************************************************************************************
--****************************************************************************************************************************
--********                                                                                   *********************************
--********	LLENAR CON BASE A LOS DATOS QUE YA SE HAYAN LLENADO EN LAS TABLAS ANTERIORES     *********************************
--********                                                                                   *********************************
--****************************************************************************************************************************
--****************************************************************************************************************************



CREATE TABLE RELACION(
	
	NumBoleta char(10), /*Incluir numero de boleta valido, ej: 2013630567, 2014630201, etc.*/
	IdGrupo varchar(5), /*Deben insertarse tal como son los grupos reales, ej: '2CM5', '2CV11', '3CM1', etc.*/
	CicloEscolar char(6), --Deben insertarse de la forma: '2014-1', '2013-2', etc.
	IdMateria varchar(5), --Deben insertarse en el formato 'C[Nivel][Dos Digito], ej: C101, C215, C332, etc. 
	IdMAESTRO char(5), --Deben insertarse en el formato '[DIGITO][DIGITO][DIGITO]' Ej: '324','452','234'
	Calificacion int NULL, --El campo debe ser NULL si actualmente el ESTUDIANTE con identificador /NumBoleta/ no ha terminado de cursar la materia con identificador /IdMateria/
	Semestre int NOT NULL, --Insertar el semestre en el que se cursa/cursó la materia (puede ser distinto al nivel en el que se debe cursar la materia)
	FormaAprobacion char(3) NULL, -- El campo será NULL si la materia se esta cursando actualmente, si ya se cursó podrá contener los valores: 'ORD', 'EXT', 'ETS'.
	PRIMARY KEY(NumBoleta, IdGrupo, CicloEscolar, IdMateria, IdMAESTRO)
);

ALTER TABLE RELACION ADD CONSTRAINT PK_RELACION_ESTUDIANTE FOREIGN KEY(NumBoleta) REFERENCES ESTUDIANTE(NumBoleta);
ALTER TABLE RELACION ADD CONSTRAINT PK_RELACION_GRUPO FOREIGN KEY(IdGrupo, CicloEscolar) REFERENCES GRUPO(IdGrupo, CicloEscolar);
ALTER TABLE RELACION ADD CONSTRAINT PK_RELACION_MATERIA FOREIGN KEY(IdMateria) REFERENCES MATERIA(IdMateria);
ALTER TABLE RELACION ADD CONSTRAINT PK_RELACION_MAESTRO FOREIGN KEY(IdMAESTRO) REFERENCES MAESTRO(IdMAESTRO);

--------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE CLASE(
	IdGrupo varchar(5),
	CicloEscolar char(6),
	IdMateria varchar(5),
	IdMAESTRO char(5),
	PRIMARY KEY (IdGrupo, CicloEscolar, IdMateria, IdMAESTRO)
	);

ALTER TABLE CLASE ADD CONSTRAINT PK_CLASE_GRUPO FOREIGN KEY (IdGrupo,CicloEscolar) REFERENCES GRUPO(IdGrupo,CicloEscolar);
ALTER TABLE CLASE ADD CONSTRAINT PK_CLASE_MATERIA FOREIGN KEY (IdMateria) REFERENCES MATERIA(IdMateria);
ALTER TABLE CLASE ADD CONSTRAINT PK_CLASE_MAESTRO FOREIGN KEY (IdMAESTRO) REFERENCES MAESTRO(IdMAESTRO);

-------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE HORARIO(
	IdGrupo varchar(5),
	CicloEscolar char(6),
	IdMateria varchar(5),
	IdMAESTRO char(5),
	Dia varchar(10),
	HoraIni Time(0) not null,
	HoraFin Time(0) not null,
	PRIMARY KEY (IdGrupo, CicloEscolar, IdMateria, IdMAESTRO, Dia)
	);
	 
ALTER TABLE HORARIO ADD CONSTRAINT PK_HORARIO_CLASE FOREIGN KEY (IdGrupo,CicloEscolar,IdMateria,IdMAESTRO) REFERENCES CLASE(IdGrupo,CicloEscolar,IdMateria,IdMAESTRO);



/******************************************************************************************************************************/
/******************************************************************************************************************************/
/******************************************************************************************************************************/
/*****************************************************************************************************************************


	I N S E R C I Ó N    D E   D A T O S


*****************************************************************************************************************************/
/******************************************************************************************************************************/
/******************************************************************************************************************************/
/******************************************************************************************************************************/



/* REGISTROS DE TABLA: ESTUDIANTE */
 
insert into ESTUDIANTE(NumBoleta,Nombre,Contraseña,Semestre,FechaIngreso,FechaNacim,Estado,Municipio,DirExtra) values
('2014650500','Escutia Alvarez Adrian','hol',1,'2014-8-1','1995-6-18','Distrito Federal','Iztapalapa','Col Santa Martha  calle Manuel Calero #43'),
('2014650501','Aguilera Rosas Enrique','holis123',1,'2014-8-1','1995-4-18','Estado de México','Chalco','Col Miravalle  calle Escutia #54'),
('2014650502','Estrella Rodriguez Juanito','yolo',1,'2014-8-1','1994-12-18','Estado de México','Chapultepec','Col Santa calle Espinoza #673'),
('2014650503','Alva Campos Victor','swag',1,'2014-8-1','1994-12-23','Distrito Federal','Gustavo A Madero','Col Potreros  calle Maldonado Kons #11'),
('2014650504','Arevalo Lopez Javier','vilchis123',1,'2014-8-1','1994-11-18','Distrito Federal','Gustavo A Madero','Col Martha  calle Manuel #43'),
('2014650505','Boza Solis Nelson','conswag',1,'2014-8-1','1994-11-13','Estado de México','Chalco','Col Amburgo  calle Cafetales y Nojosa #788'),
('2014650506','Corre Moreno Doris','leagueof',1,'2014-8-1','1995-7-16','Estado de México','Chimalhuacán','Col San Juan  AV Mouse y Click #33'),
('2014650507','Diaz Salinas María','desof13',1,'2014-8-1','1994-12-22','Distrito Federal','Coyoacán','Col Agricola Oriental  calle Nogales #123'),
('2014650508','Ferro Salgas Olga','pandora12',1,'2014-8-1','1994-12-18','Distrito Federal','Cuauhtémoc','Col Cafora  calle Ambruno #145'),
('2014650509','Garcia Peralta Miriam','sonia43',1,'2014-8-1','1995-11-22','Estado de México','Cocotitlán','Col Mercenario  calle Toful #4563'),
('2014650510','Moreno Zarate Victor','subzero',1,'2014-8-1','1994-11-22','Estado de México','Chalco','Col Nativitas  calle Xoco #123'),
('2014650511','Guzman Clispe Clara','scorpion',1,'2014-8-1','1995-6-11','Distrito Federal','Iztapalapa','Col Nápoles  calle Periodista #4554'),
('2014650512','Flores Diaz Edgar','blackpanter',1,'2014-8-1','1995-3-14','Estado de México','Chapultepec','Col Ermita calle Francia #435'),
('2014650513','Lijan Venega Hector','magneto',1,'2014-8-1','1995-12-11','Distrito Federal','Iztapalapa','Col Republica del Salvador  calle Noche#478'),
('2014650514','Maldonado Celentino Brian','doggy324',1,'2014-8-1','1995-1-1','Estado de México','Jaltelco','Col Piedad Narvante  calle 8 de Agosto #233'),
('2014650515','Ore Reyes Olga','esparaza456',1,'2014-8-1','1992-11-11','Distrito Federal','Xochimilco','Col Cristal  calle Potrería #65'),
('2014650516','Bermejo Diaz Tlatoani','123doug',1,'2014-8-1','1995-11-12','Distrito Federal','Iztapalapa','Col Mixcoac  calle Mixcoac #432'),
('2014650517','Orillo Castillo Josue','thuglife123',1,'2014-8-1','1995-1-18','Estado de México','Ixtlahuaca','Col Santa Martha  calle Manuel Calero #234'),
('2014650518','Prado Vilches Sonia','peralta1839',1,'2014-8-1','1996-12-18','Distrito Federal','Coyoacán','Col Villa de Cortéz  calle Independencia #2453'),
('2014650519','Prado Astorga Miguel','89sosa',1,'2014-8-1','1994-12-18','Distrito Federal','Azcapotzalco','Col Del Valle  calle Antonio Caso #243'),
('2014650520','Xara Leon Pedro','clarence12',1,'2014-8-1','1995-8-13','Estado de México','Chalco','Col Edgarito  calle María Morelos #43'),
('2014650521','Rodriguez Velazco Josue','bigpoint',1,'2014-8-1','1994-12-18','Estado de México','Chalco','Col Etiopia  calle Bassols #143'),
('2014650522','Silva Flores Karlos','holis123',1,'2014-8-1','1995-9-12','Distrtito Federal','Chapultepec','Col Postal  calle Juan de Dios Bátiz #4674'),
('2014650523','Rios Lima Teresa','13lolKOk',1,'2014-8-1','1994-9-18','Distrito Federal','Iztapalapa','Col Santa Insurgentes  calle NoOne #32'),
('2014650524','Tenorio Miguel Angel','hHDHD',1,'2014-8-1','1995-3-12','Distrito Federal','Iztapalapa','Col Santa Martha  calle Manuel Calero #21'),
('2014650525','Zuñiga Garcia Manuel','ferraGomez',1,'2014-8-1','1994-10-11','Distrito Federal','Coyoacán','Col Iturbide calle Asunción #89'),
('2014650526','Vasquez Guerra Victor','FeedOp',1,'2014-8-1','1995-11-11','Estado de México','Chimalhuacán','Col Julios calle isdeath #89'),
('2014650527','Uriarte Lechuga','kdjfdf',1,'2014-8-1','1995-4-23','Estado de México','Cocotitlan','Col Granjas calle Perdón #123'),
('2014650528','Vera Silva Alejandro','adcop',1,'2014-8-1','1995-11-11','Distrito Federal','Coyoacán','Col las abejas calle cuarta #32'),
('2014650529','Trujillo Parodi Jacquelin','parodiaq3',1,'2014-8-1','1995-7-16','Estado de México','Chimalhuacán','Col Pino  AV Mouse y Click #33'),
('2014650530','Verta Umbrena Karlos','heimer',1,'2014-8-1','1995-11-25','Distrito Federal','Coyoacán','Col La Paz  calle Pencilone #123'),
('2014650531','Solis Huerta Carla','yasuo',1,'2014-8-1','1994-12-31','Distrito Federal','Cuauhtémoc','Col Granjas QUinta  calle Mayo #145'),
('2014650532','Prado Estrada Miguel','warwick',1,'2014-8-1','1995-4-4','Estado de México','Cocotitlán','Col Juan de dios Batiz  calle Toful #4563'),
('2014650533','Unario Gaspar Tenorio','scorpion43',1,'2014-8-1','1995-10-5','Estado de México','Chalco','Col Insurgentes  calle Bachoco #123'),
('2014650534','Pedraza Anuack Cecilia','scorpiondar',1,'2014-8-1','1995-4-13','Distrito Federal','Iztapalapa','Col Roma  calle Quinta #4554'),
('2014650535','Knock Anuar Francisco','blackpanter',1,'2014-8-1','1994-5-13','Estado de México','Chapultepec','Col Bolivar calle Francia #435'),
('2014650536','Veigar Morris Cristina','serializable',1,'2014-8-1','1995-2-1','Distrito Federal','Iztapalapa','Col Salvador  calle Noche Buena #478'),
('2014650537','Mongo Urte knuth','plumma',1,'2014-8-1','1994-11-15','Estado de México','Jaltelco','Col Cristal  calle Juliis #233'),
('2014650538','Payaso Manco Duarte','lapuerta',1,'2014-8-1','1996-1-11','Distrito Federal','Xochimilco','Col Potreros  calle San Proth #65'),
('2014650539','Pacheco Diaz Victor','thedoors',1,'2014-8-1','1995-11-12','Distrito Federal','Iztapalapa','Col Mutiz  calle Asunción #432'),
('2014650540','Salcedo del Pino Gustavo','styleop',1,'2014-8-1','1994-12-18','Estado de México','Ixtlahuaca','Col Paraíso  calle Primera #234'),
('2014650541','Rodriguez Peredo Ignacio','pinkfloyd123',1,'2014-8-1','1996-1-28','Distrito Federal','Coyoacán','Col Villa de Cortéz  calle Independencia #2453'),
('2014650542','Tejedo Luna Tania','Illinkut',1,'2014-8-1','1995-11-12','Distrito Federal','Azcapotzalco','Col Del Valle  calle Antonio Caso #243'),
('2014650543','Guzman Notorio Andres','cladfdf',1,'2014-8-1','1995-8-13','Estado de México','Chalco','Col Etiopia  calle Ponky #43'),
('2014650544','NoOne Pedraz Pedro','solial',1,'2014-8-1','1994-12-18','Estado de México','Chalco','Col Oceania  calle Misterios #143'),
('2014650545','Josuack Renton Miguel','megadeth13',1,'2014-8-1','1995-9-12','Distrtito Federal','Chapultepec','Col Pantitlán  calle Osorio #4674'),
('2014650546','Peredo Samuel Brandon','caifaneseee',1,'2014-8-1','1994-9-18','Distrito Federal','Iztapalapa','Col Santa Insurgentes  calle NoOne #32'),
('2014650547','Santiago Belmontez Rebeca','megmuerte432',1,'2014-8-1','1995-3-12','Distrito Federal','Iztapalapa','Col Santa Martha  calle Manuel Calero #21'),
('2014650548','Yisu Urli Dianna','dariuspaoi',1,'2014-8-1','1994-10-11','Distrito Federal','Coyoacán','Col Iturbide calle Asunción #89'),
('2014650549','Juan Pistolas Dorantes','peppa',1,'2014-8-1','1995-11-11','Estado de México','Chimalhuacán','Col Julios calle isdeath #89'),
('2014650550', 'Trejo Martinez Francisco','afx',1, '2014-8-1','1994-10-13', 'Estado de Mexico','Ecatepec','Col Las Americas Calle Independencia Casa 8A'),
('2014650551', 'Uriarte Reyes Alexis','paradox13',1, '2014-8-1','1995-01-16', 'Morelos','Cuautla','Col Prados Calle Laredo #34'),
('2014650552', 'Perez Melendez Juana','xd',1, '2014-8-1','1994-05-16', 'Estado de Mexico','Ecatepec','Col Jardines de Morelos Calle Lagos de San Jose #98'),
('2014650553', 'Ireta Ramales Andres','soyunhobbit',1, '2014-8-1','1994-06-20', 'Distrito Federal','Iztapalapa','Col Las Flores Calle Benito Juarez #2'),
('2014650554', 'Chavez Pereda Juan Jesus','jesuisjesus',1, '2014-8-1','1994-12-01', 'Distrito Federal','Gustavo A Madero','Col Miguel Hidalgo Calle Luis Muñoz #103'),
('2014650555', 'Trinidad y Tobago Teresa','jijiji',1, '2014-8-1','1995-08-02', 'Distrito Federal','Benito Juarez','Col Candelaria Calle Fuego Lento #7'),
('2014650556', 'Huerta Hermoso Hugo','HHH',1, '2014-8-1','1995-02-28', 'Estado de Mexico','Ixtlahuaca','Col Peregrinos Calle Treboles #65'),
('2014650557', 'Bustamante Castro Narciso','queondukipaps',1, '2014-8-1','1995-08-02', 'Distrito Federal','Gustavo A Madero','Col Torres Lindavista Calle Santa Anna Sur Casa 3C'),
('2014650558', 'De la Huerta Rosales Maria del Carmen','mimamamemima',1, '2014-8-1','1994-01-01', 'Distrito Federal','Milpa Alta','Col Crisantemos Calle Dos #5'),
('2014650559', 'Rodriguez Ramos Alejandro David','nosoyhipster',1, '2014-8-1','1995-12-21', 'Estado de Mexico','Ecatepec de Morelos','Col Libertadores de America Calle Simon Bolivar #34'),
('2014650560', 'Fernandez García Georgina','BlueHawaii',1, '2014-8-1','1995-11-11', 'Distrito Federal','Milpa Alta','Col Milpa Alta Calle Rosarios #545'),
('2014650561', 'Mata Cortes Valeria','uoiea333',1, '2014-8-1','1995-03-5', 'Estado de Mexico','Ectapec de Morelos','Col Granadas Calle Hortigas #33'),
('2014650562', 'Gutierrez Castro Jesus Antonio','nain77',1, '2014-8-1','1995-09-09', 'Estado de Mexico','Ecatepec de Morelos','Col Ciudad Azteca Calle Robledo #7'),
('2014650563', 'Zarate Castillo Edgar Ramses','wut',1, '2014-8-1','1995-12-28', 'Distrito Federal','Coyoacán','Col Villa de Cortéz Calle Leones #120'),
('2014650564', 'Mirado Rueda Jose','ruedarueda12',1, '2014-8-1','1994-09-08', 'Estado de Mexico','Ixtlahuaca','Col Peregrinos Calle Treboles #68'),
('2014650565', 'León Trejo Nancy','warning',1,'2014-8-1','1993-05-04','Distrito Federal','Gustavo A Madero','Col la Forestal calle Castillos #455'),
('2014650566', 'Mondragon Ro Julieta','pjui55',1,'2014-8-1','1995-6-11','Distrito Federal','Coyoacán','Col Agricola Oriental Calle Granadina #93'),
('2014650567', 'Aguilar Castan Sharon','choochoo',1, '2014-8-1','1995-09-24', 'Estado de Mexico','Tecamac','Col Los Heroes 5ta Seccion Calle Mariano Escobedo #41'),
('2014650568', 'Ake kob Valdez Ingrid','iakv44',1,'2014-8-1','1995-10-31','Estado de México','Ixtlahuaca','Col Santa Martha  calle Manuel Calero #234'),
('2014650569', 'Flores May Yolanda','PerfumeGenius',1,'2014-8-1','1995-1-18','Estado de México','Chalco','Col Diente de Leon calle Oregon #13'),
('2014650570', 'Belio Rangel Cesar','codex1234567',1,'2014-8-1','1994-08-19','Michoacan','Ixtlan','Col Zamora Calle Allende #222'),
('2014650571', 'Palacios Linderman Axel','getoffmycase',1,'2014-8-1','1995-10-01','Distrito Federal','Cuahutémoc','Col Hermosillo calle Francia #343'),
('2014650572', 'Robledo Juarez Orlando','ImMovingOutOfOrbit',1,'2014-8-1','1996-03-18','Distrito Federal','Cuauhtémoc','Col Centro calle Republica del Salvador #32'),
('2014650573', 'Ortiz Limon Tania','listentoyourheart',1,'2014-8-1','1996-04-25','Distrito Federal','Cuauhtémoc','Col Condesa calle Nuevo Leon #67'),
('2014650574', 'Luna Dolán Ameliée','HuntingBears',1,'2014-8-1','1994-08-09','Distrito Federal','Cuauhtémoc','Col Roma Norte calle Queretaro #102'),
('2014650575', 'Rivas de la Torre Juan Carlos','eazy556',1,'2014-8-1','1994-12-20','Distrito Federal','Benito Juarez','Col El Prado calle Michoacan #11'), 
('2014650576', 'Granados Suarez Bruno','789iue',1,'2014-8-1','1993-04-17','Estado de Mexico','Amecameca','Col Amecameca de Juarez calle Laredo #98'),
('2014650577', 'Hernandez Ruiz Guadalupe','ijfskdf',1,'2014-8-1','1995-08-07','Estado de Mexico','Ectaepec','Col San Cristobal calle Obregón #166'),
('2014650578', 'Juarez Hernandez Diana','solarsistema',1,'2014-8-1','1996-12-02','Estado de Mexico','Metepec','Col Trujillo calle Feligreces #23'),
('2014650579', 'Zuñiga Ortiz Oscar','twobodies11',1,'2014-8-1','1996-08-02','Estado de Mexico','La Paz','Col Los Reyes calle Trinidad #101'),
('2014650580', 'Pradera Fuentes Mateo','ourtongues98',1,'2014-8-1','1994-05-15','Estado de Mexico','Tlalnepantla','Col Villas calle Cielo Rojo #332'),
('2014650581', 'Mercedes Iturbe Elizabeth','contraseña',1,'2014-8-1','1995-10-10','Distrito Federal','Xochimilco','Col Asuncion calle Oaxaca #4'),
('2014650582', 'Nayarit Esinoza Cesar','2014650582',1,'2014-8-1','1995-02-09','Distrito Federal','Gustavo A Madero','Col Arbolillo calle Lopez Portillo #55'),
('2014650583', 'Higareda Fonseca Aline','sweet33',1,'2014-8-1','1993-12-10','Distrito Federal','Gustavo A Madero','Col 6 de Junio Calle Prados #7'),
('2014650584', 'Rivera Castillo Martha','ricama44',1,'2014-8-1','1995-03-30','Distrito Federal','Gustavo A Madero','Col Bondojito calle 8 de Marzo #55'),
('2014650585', 'Diaz Fernandez Karina','kari85',1,'2014-8-1','1994-08-29','Distrito Federal','Gustavo A Madero','Col Granjas Modernas calle Iturbide #9'),
('2014650586', 'Pinos Ramos Edwin','cccbbaa',1,'2014-8-1','1994-02-27','Distrito Federal','Xochimilco','Col Asuncion calle Oaxaca #4'),
('2014650587', 'Ybañez Del Pedregal Enrique','oopoo',1,'2014-8-1','1995-08-08','Distrito Federal','Venustiano Carranza','Col Nicolas Bravo calle Madero #55'),
('2014650588', 'Buendia Verde Juan Luis','cryinginyourface',1,'2014-8-1','1995-08-14','Distrito Federal','Venustiano Carranza','Col Sevilla calle Circunvalalacion #102'),
('2014650589', 'Cancino Lopez Lucrecia','holi123',1,'2014-8-1','1994-05-08','Distrito Federal','Venustiano Carranza','Col Stand de Tiro calle Obregon s/n esq Calle Alvarado'),
('2014650590', 'Ejido Huerta Edmundo','mypassword',1,'2014-8-1','1995-10-11','Distrito Federal','Venustiano Carranza','Col Tres Mosqueteros calle Ortiga #111'),
('2014650591', 'Querubin Lopez Rodrigo','notengocontraseña',1,'2014-8-1','1995-08-18','Distrito Federal','Azcapotzalco','Col El Recreo calle Juan Felipe #202'),
('2014650592', 'Amparo Torres Jose de Jesus','josedejesus43',1,'2014-8-1','1994-09-28','Distrito Federal','Azcapotzalco','Col San Miguel Amantla calle Ricardo Flores Magón #2'),
('2014650593', 'Berbena Ponce Daniel Wilfrido','danwil94',1,'2014-8-1','1994-03-16','Distrito Federal','Gustavo A Madero','Col Emiliano Zapata calle 10 de Febrero #208'),
('2014650594', 'Manzana Muñoz Monica','mmmx3',1,'2014-8-1','1995-12-30','Distrito Federal','Gustavo A Madero','Col La Esmerelda calle Esmeralda #7'),
('2014650595', 'Daza Martinez Hiram','fierroparriente',1,'2014-8-1','1993-07-11','Distrito Federal','Gustavo A Madero','Col Lindavista Norte calle Hermosillo #9'),
('2014650596', 'Jaramillo Hernadez Mauricio','gohomebro',1,'2014-8-1','1994-11-11','Distrito Federal','Gustavo A Madero','Col Lindavista Norte calle Hermosillo #26'),
('2014650597', 'Ramalho Asturias Abraham','abraham',1,'2014-8-1','1994-12-01','Distrito Federal','Gustavo A Madero','Col Lindavista Sur calle Lindavista #13'),
('2014650598', 'Alvarado Fonseca Jair','lifeafterdefo',1, '2014-8-1','1995-03-28', 'Distrito Federal','Coyoacán','Col Villa de Cortéz Calle Leones #113'),
('2014650599', 'León Pereda Jimena','lpj12',1, '2014-8-1','1995-12-12','Estado de Mexico','Tlalnepantla','Col Villas calle Cielo Rojo #332');


/* REGISTROS DE TABLA: ESTUDIANTE_TELEFONO */

insert into ESTUDIANTE_TELEFONO (NumBoleta,Telefono) values

('2014650500','5536674949'),
('2014650501','5536674435'),
('2014650502','5536674349'),
('2014650503','5536673434'),
('2014650504','5536674239'),
('2014650505','5536234494'),
('2014650506','5536674549'),
('2014650507','5536654333'),
('2014650508','5531233443'),
('2014650509','5536542234'),
('2014650510','5512323434'),
('2014650511','5536234234'),
('2014650512','5543332434'),
('2014650513','5554335434'),
('2014650514','5536678776'),
('2014650515','5587876877'),
('2014650516','5587654545'),
('2014650517','5536456467'),
('2014650518','5536677766'),
('2014650519','5537657656'),
('2014650520','5536674564'),
('2014650521','5534534566'),
('2014650522','5543343454'),
('2014650523','5536765756'),
('2014650524','5536576576'),
('2014650525','5536608989'),
('2014650526','5532342344'),
('2014650527','5536543542'),
('2014650528','5536234294'),
('2014650529','5536634349'),
('2014650530','5535434349'),
('2014650531','5536654354'),
('2014650532','5535434532'),
('2014650533','5536543543'),
('2014650534','5536634534'),
('2014650535','5536543353'),
('2014650536','5536234523'),
('2014650537','5532345235'),
('2014650538','5536672343'),
('2014650539','5536634555'),
('2014650540','5536622222'),
('2014650541','5536654334'),
('2014650542','5533453229'),
('2014650543','5536345666'),
('2014650544','5523332423'),
('2014650545','5536687665'),
('2014650546','5536678656'),
('2014650547','5556767669'),
('2014650548','5536674949'),
('2014650549','5536567567'),
('2014650550', '5534546576'),
('2014650551', '5546568666'),
('2014650552', '5567897998'),
('2014650553', '5523456565'),
('2014650554', '5598087652'),
('2014650555', '5523415342'),
('2014650556', '5509873674'),
('2014650557', '5534523417'),
('2014650558', '5509893674'),
('2014650559', '5534235167'),
('2014650560', '5524398746'),
('2014650561', '5599330284'),
('2014650562', '5566498980'),
('2014650563', '5533989833'),
('2014650564', '5522908987'),
('2014650565', '5509098749'),
('2014650566', '5503938374'),
('2014650567', '5565338989'),
('2014650568', '5598979798'),
('2014650569', '5576868509'),
('2014650570', '5523452334'),
('2014650571', '5524243908'),
('2014650572', '5598050567'),
('2014650573', '5598987638'),
('2014650574', '5567879833'),
('2014650575', '5509898987'), 
('2014650576', '5576879876'), 
('2014650578', '5548394433'),
('2014650579', '5564579899'),
('2014650580', '5598777676'),
('2014650581', '5534232323'),
('2014650582', '5543434343'),
('2014650583', '5567890987'),
('2014650584', '5511213141'),
('2014650585', '5534567890'),
('2014650586', '5518283848'),
('2014650587', '5576567656'),
('2014650588', '5567887667'),
('2014650589', '5598987633'),
('2014650590', '5565645777'),
('2014650591', '5564879877'),
('2014650592', '0550098987'),
('2014650593', '5511223344'),
('2014650594', '5509569444'),
('2014650595', '5587657876'),
('2014650596', '5587878766'),
('2014650597', '5534233222'),
('2014650598', '5501232323'),
('2014650599', '5587678988');



/* REGISTROS DE TABLA: GRUPO */

insert into GRUPO (idGrupo,CicloEscolar,Salon) values 
('1CM1','2015-1',1001),
('1CM2','2015-1',1002),
('1CM3','2015-1',1003),
('1CM4','2015-1',1004),
('1CM5','2015-1',1005),
('1CM6','2015-1',1006),
('1CM7','2015-1',1007),
('1CM8','2015-1',1008),
('1CM9','2015-1',1009),
('1CM10','2015-1',1201),
('1CM11','2015-1',1202),
('1CM12','2015-1',1203),
('1CM13','2015-1',1204),
('1CM14','2015-1',1205),
('1CM15','2015-1',1206), 
('1CV1','2015-1',1001),
('1CV2','2015-1',1002),
('1CV3','2015-1',1003),
('1CV4','2015-1',1004),
('1CV5','2015-1',1005),
('1CV6','2015-1',1006),
('1CV7','2015-1',1007),
('1CV8','2015-1',1008),
('1CV9','2015-1',1009),
('1CV10','2015-1',1201),
('1CV11','2015-1',1202),
('1CV12','2015-1',1203),
('1CV13','2015-1',1204),
('1CV14','2015-1',1205),
('1CV15','2015-1',1206); 


/* REGISTROS DE TABLA: MATERIA */

INSERT INTO MATERIA (IdMateria, Nombre, Obligatoria) values
('C101','ANALISIS VECTORIAL',1),
('C102','CALCULO',1),
('C103','MATEMATICAS DISCRETAS',1),
('C104','ALGORITMIA Y PROGRAMACION ESTRUCTURADA',1),
('C105','FISICA',1),
('C106','INGENIERIA ETICA Y SOCIEDAD',1),
('C107','ECUACIONES DIFERENCIALES',1),
('C108','ALGEBRA LINEAL',1),
('C109','CALCULO APLICADO',1),
('C110','ESTRUCTURAS DE DATOS',1),
('C111','COMUNICACION ORAY Y ESCRITA',1),
('C112','ANAlISIS FUNDAMENTAL DE CIRCUITOS',1),

('C213','MATEMATICAS AVANZADAS PARA LA INGENIERIA',1),
('C214','FUNDAMENTOS ECONOMICOS',1),
('C215','FUNDAMENTOS DE DISEÑO DIGITAL',1),
('C216','TEORIA COMPUTACIONAL',1),
('C217','BASES DE DATOS',1),
('C218','PROGRAMACION ORIENTADA A OBJETOS',1),
('C219','ELECTRONICA ANALOGICA',1),

('C220','REDES DE COMPUTADORAS',1),
('C221','DISEÑO DE SISTEMAS DIGITALES',1), 
('C222','PROBABILIDAD Y ESTADISTICA',1),
('C223','SISTEMAS OPERATIVOS',1),
('C224','ANALISIS Y DISEÑO ORIENTADO A OBJETOS',1),
('C225','TECNOLOGIAS PARA LA WEB',1),
('C226','ADMINISTRACION FINANCIERA',1)
;


/* REGISTROS DE TABLA: MAESTRO */

insert into MAESTRO(IdMAESTRO,Nombre,Grado) values 
(101,'Benjamín López Carrera','DOCTOR'),
(102,'Benjamín Luna Benoso','DOCTOR'),
(103,'Héctor Manuel Manzanilla Granados','DOCTOR'),
(104,'Manuel Salazar Ramírez','DOCTOR'),
(105,'Miguel Santiago  Suárez Castañón','DOCTOR'),
(106,'Ricardo Barrón Fernández','DOCTOR'),
(107,'Claudia Celia Díaz Huerta','DOCTOR'),
(108,'Edith Adriana Jiménez Contreras','DOCTOR'),
(109,'Naria Adriana Flores Fuentes','DOCTOR'),
(110,'Olga Kolesnikova','DOCTOR'),
(111,'Saúl De la O Torres','INGENIERIA'),
(112,'Juan Vicente García Sales','INGENIERIA'),
(113,'Eduardo Chávez Lima','LICENCIATURA'),
(114,'Leticia Cañedo Suárez','LICENCIATURA'),
(115,'Roberto De Luna Caballero','LICENCIATURA'),
(116,'Rocío Reséndiz Muñoz','LICENCIATURA'),
(117,'Tlatoani de Jesús Reyes Bermejo','LICENCIATURA'),
(118,'Alejandro González Cisneros','MAESTRIA'),
(119,'Alfredo Rangel Guzmán','MAESTRIA'),
(120,'Ángel Adalberto Durán Ledezma','MAESTRIA'),
(121,'Carlos Jesús Pastrana Fernández','MAESTRIA'),
(122,'Carlos Juárez León','MAESTRIA'),
(123,'César Román Martínez García','MAESTRIA'),
(124,'Claudia Jisela Dorantes Villa','MAESTRIA'),
(125,'Crispin Herrera Yañez','MAESTRIA'),
(126,'Daniel Cruz García','MAESTRIA'),
(127,'Darwin Gutiérrez Mejía','MAESTRIA'),
(128,'Didier Ojeda Guillén','MAESTRIA'),
(129,'Florencio Guzmán Aguilar','MAESTRIA'),
(130,'Ignacio Ríos de la Torre','MAESTRIA'),
(131,'Israel Buitrón Damaso','MAESTRIA'),
(132,'Iván Giovanny Mosso García','MAESTRIA'),
(133,'Jesús Alfredo Martínez Nuño','MAESTRIA'),
(134,'Jesús Ortuño Araujo','MAESTRIA'),
(135,'José Carlos Dávalos López','MAESTRIA'),
(136,'José David Ortega Pacheco','MAESTRIA'),
(137,'Juan Jesús Gutiérrez García','MAESTRIA'),
(138,'Karina Viveros Vela','MAESTRIA'),
(139,'Laura Lazcano Xoxotla','MAESTRIA'),
(140,'Lilian Martínez Acosta','MAESTRIA'),
(141,'Luis Manuel Cabrera Chim','MAESTRIA'),
(142,'María Susana Sánchez Palacios','MAESTRIA'),
(143,'Miguel Abel León Hernández','MAESTRIA'),
(144,'Miguel Ángel González Trujillo','MAESTRIA'),
(145,'Miguel Olvera Aldana','MAESTRIA'),
(146,'Miriam Pescador Rojas','MAESTRIA'),
(147,'Misael Solorza Guzmán','MAESTRIA'),
(148,'Reyna Elia Melara Abarca','MAESTRIA'),
(149,'Ricardo Ceballos Sebastián','MAESTRIA'),
(150,'Roberto Jurado Jiménez','MAESTRIA'),
(151,'Roberto Tecla Parra','MAESTRIA'),
(152,'Gumersindo Vera Hernández','MAESTRIA'),
(153,'Ana María Winfield Reyes','DOCTOR'),
(154,'Sandra Mercedes Pérez Vera','LICENCIATURA'),
(155,'Gisela González Albarrán','MAESTRIA'),


('156','Angel Morales Gonazalez','DOCTORADO'),
('157','Monserrat Grabriela Perez Vera','DOCTORADO'),
('158','Zelin Miguel Pilar','DOCTORADO'),
('159','Jazmin Adriana Juarez Ramirez','DOCTORADO'),
('160','Luis Moctezuma Cervantes Espinoza','DOCTORADO'),
('161','Encarnacion Salinas Hernandez','DOCTORADO'),
('162','Juan Jose Torres Manriquez','DOCTORADO'),
('163','Martha Patricia Jimenez Villas','DOCTORADO'),
('164','Elena Fabiola Ruiz Ledezma','DOCTORADO'),
('165','Yaxkin Flores Mendoza','DOCTORADO'),
('166','Jesus Yalja Montiel Perez','DOCTORADO'),
('167','Marco Antonio Rueda Melendez','DOCTORADO'),
('168','Jose Sanchez Juarez','DOCTORADO'),
('169','Maribel Aragon Garcia','DOCTORADO'),
('170','Adriana Berenice Celis Dominguez ','DOCTORADO'),
('171','Rocio Almazan Farfan','DOCTORADO'),
('172','ALberto Jesus Alcantara Mendez','DOCTORADO'),
('173','Sergio Cancino Calderon','DOCTORADO'),
('174','Felipe de Jesus Figueroa del Prado ','DOCTORADO');


/* REGISTROS DE TABLA: CLASE */

INSERT INTO CLASE (IdGrupo,CicloEscolar,IdMateria, IdMAESTRO) VALUES 
('1CM1','2015-1','C101','145'), 
('1CM1','2015-1','C102','124'),
('1CM1','2015-1','C103','132'),
('1CM1','2015-1','C104','112'),
('1CM1','2015-1','C105','156'),
('1CM1','2015-1','C106','157'), 

('1CM2','2015-1','C101','158'),
('1CM2','2015-1','C102','138'),
('1CM2','2015-1','C103','132'),
('1CM2','2015-1','C104','105'),
('1CM2','2015-1','C105','101'),
('1CM2','2015-1','C106','152'), 

('1CM3','2015-1','C111','169'),
('1CM3','2015-1','C102','159'),
('1CM3','2015-1','C103','117'),
('1CM3','2015-1','C104','121'),
('1CM3','2015-1','C105','118'),
('1CM3','2015-1','C106','157'), 

('1CM4','2015-1','C111','154'),
('1CM4','2015-1','C102','123'),
('1CM4','2015-1','C103','117'),
('1CM4','2015-1','C104','116'),
('1CM4','2015-1','C105','118'),
('1CM4','2015-1','C106','152'),

('1CM5','2015-1','C111','169'),
('1CM5','2015-1','C102','147'),
('1CM5','2015-1','C103','117'),
('1CM5','2015-1','C104','115'),
('1CM5','2015-1','C105','129'),
('1CM5','2015-1','C106','152'),

('1CM6','2015-1','C111','169'),
('1CM6','2015-1','C102','147'),
('1CM6','2015-1','C103','110'),
('1CM6','2015-1','C104','115'),
('1CM6','2015-1','C105','129'),
('1CM6','2015-1','C106','157'),

('1CM7','2015-1','C111','169'),
('1CM7','2015-1','C102','103'),
('1CM7','2015-1','C103','142'),
('1CM7','2015-1','C104','116'),
('1CM7','2015-1','C105','149'),
('1CM7','2015-1','C106','170'),

('1CM8','2015-1','C111','160'),
('1CM8','2015-1','C102','123'),
('1CM8','2015-1','C103','142'),
('1CM8','2015-1','C104','151'),
('1CM8','2015-1','C105','109'),
('1CM8','2015-1','C106','157'),

('1CM9','2015-1','C101','145'),
('1CM9','2015-1','C107','161'),
('1CM9','2015-1','C108','114'),
('1CM9','2015-1','C109','114'),
('1CM9','2015-1','C110','166'),
('1CM9','2015-1','C112','173'),
 
('1CM10','2015-1','C101','140'),
('1CM10','2015-1','C107','108'),
('1CM10','2015-1','C108','103'),
('1CM10','2015-1','C109','124'),
('1CM10','2015-1','C110','167'),
('1CM10','2015-1','C112','171'),

 
('1CM11','2015-1','C101','128'),
('1CM11','2015-1','C107','161'),
('1CM11','2015-1','C108','162'),
('1CM11','2015-1','C109','164'),
('1CM11','2015-1','C110','167'),
('1CM11','2015-1','C112','173'),

('1CM12','2015-1','C101','120'),
('1CM12','2015-1','C108','130'),
('1CM12','2015-1','C109','163'),
('1CM12','2015-1','C110','165'),
('1CM12','2015-1','C112','173'),
-----------------------
('1CM13','2015-1','C101','158'),
('1CM13','2015-1','C102','124'),
('1CM13','2015-1','C107','160'),
('1CM13','2015-1','C108','114'),
('1CM13','2015-1','C109','163'),
('1CM13','2015-1','C110','165'),
('1CM13','2015-1','C112','172'),
-----------------------
('1CM14','2015-1','C103','113'),
('1CM14','2015-1','C104','102'),
('1CM14','2015-1','C105','109'),
('1CM14','2015-1','C108','149'),
('1CM14','2015-1','C110','116'),
('1CM14','2015-1','C112','172'),
-----------------------
('1CM15','2015-1','C102','159'),
('1CM15','2015-1','C103','106'),
('1CM15','2015-1','C105','101'),
('1CM15','2015-1','C107','160'),
('1CM15','2015-1','C109','114'),
('1CM15','2015-1','C110','168'),
('1CM15','2015-1','C112','174')


/* REGISTROS DE TABLA: HORARIO */
INSERT INTO HORARIO (IdGrupo,CicloEscolar,IdMateria,IdMAESTRO,Dia, HoraIni, HoraFin) values

('1CM1','2015-1','C101','145','Lunes','07:00:00','08:30:00'),
('1CM1','2015-1','C105','156','Lunes','08:30:00','10:00:00'),
('1CM1','2015-1','C106','157','Lunes','10:30:00','12:00:00'),
('1CM1','2015-1','C104','112','Lunes','12:00:00','13:30:00'),
('1CM1','2015-1','C103','132','Lunes','13:30:00','15:00:00'),
-------------------------------------------------------
('1CM1','2015-1','C102','124','Martes','07:00:00','08:30:00'),
('1CM1','2015-1','C106','157','Martes','08:30:00','10:00:00'),
('1CM1','2015-1','C103','132','Martes','10:30:00','12:00:00'),
-------------------------------------------------------
('1CM1','2015-1','C102','124','Miercoles','07:00:00','08:30:00'),
('1CM1','2015-1','C105','156','Miercoles','08:30:00','10:00:00'),
('1CM1','2015-1','C103','132','Miercoles','10:30:00','12:00:00'),
('1CM1','2015-1','C104','112','Miercoles','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM1','2015-1','C101','145','Jueves','07:00:00','08:30:00'),
('1CM1','2015-1','C105','156','Jueves','08:30:00','10:00:00'),
('1CM1','2015-1','C106','157','Jueves','10:30:00','12:00:00'),
('1CM1','2015-1','C104','112','Jueves','12:00:00','13:30:00'),
---------------------------------------------------------
('1CM1','2015-1','C102','124','Viernes','07:00:00','08:30:00'),
('1CM1','2015-1','C101','145','Viernes','08:30:00','10:00:00'),
('1CM1','2015-1','C103','132','Viernes','10:30:00','12:00:00'),
---------------------------------------------------------


---------------------------------------------------------
('1CM2','2015-1','C104','105','Lunes','07:00:00','08:30:00'),
('1CM2','2015-1','C102','138','Lunes','08:30:00','10:00:00'),
('1CM2','2015-1','C105','101','Lunes','10:30:00','12:00:00'),
('1CM2','2015-1','C103','132','Lunes','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM2','2015-1','C101','158','Martes','07:00:00','08:30:00'),
('1CM2','2015-1','C105','101','Martes','08:30:00','10:00:00'),
('1CM2','2015-1','C106','152','Martes','10:30:00','12:00:00'),
('1CM2','2015-1','C103','132','Martes','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM2','2015-1','C101','158','Miercoles','07:00:00','08:30:00'),
('1CM2','2015-1','C102','138','Miercoles','08:30:00','10:00:00'),
('1CM2','2015-1','C106','152','Miercoles','10:30:00','12:00:00'),
('1CM2','2015-1','C103','132','Miercoles','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM2','2015-1','C104','105','Jueves','07:00:00','08:30:00'),
('1CM2','2015-1','C102','138','Jueves','08:30:00','10:00:00'),
('1CM2','2015-1','C105','101','Jueves','10:30:00','12:00:00'),
('1CM2','2015-1','C103','132','Jueves','12:00:00','13:30:00'),
-------------------------------------------------------------
('1CM2','2015-1','C101','158','Viernes','07:00:00','08:30:00'),
('1CM2','2015-1','C104','105','Viernes','08:30:00','10:00:00'),
('1CM2','2015-1','C106','152','Viernes','10:30:00','12:00:00'),
---------------------------------------------------------------



---------------------------------------------------------------
('1CM3','2015-1','C103','117','Lunes','07:00:00','08:30:00'),
('1CM3','2015-1','C102','159','Lunes','08:30:00','10:00:00'),
('1CM3','2015-1','C111','169','Lunes','10:30:00','12:00:00'),
('1CM3','2015-1','C106','157','Lunes','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM3','2015-1','C104','121','Martes','07:00:00','08:30:00'),
('1CM3','2015-1','C103','117','Martes','08:30:00','10:00:00'),
('1CM3','2015-1','C105','118','Martes','10:30:00','12:00:00'),
('1CM3','2015-1','C111','169','Martes','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM3','2015-1','C104','121','Miercoles','07:00:00','08:30:00'),
('1CM3','2015-1','C102','159','Miercoles','08:30:00','10:00:00'),
('1CM3','2015-1','C105','118','Miercoles','10:30:00','12:00:00'),
('1CM3','2015-1','C106','157','Miercoles','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM3','2015-1','C103','117','Jueves','07:00:00','08:30:00'),
('1CM3','2015-1','C102','159','Jueves','08:30:00','10:00:00'),
('1CM3','2015-1','C106','157','Jueves','10:30:00','12:00:00'),
('1CM3','2015-1','C111','169','Jueves','12:00:00','13:30:00'),
-------------------------------------------------------------
('1CM3','2015-1','C104','121','Viernes','07:00:00','08:30:00'),
('1CM3','2015-1','C103','117','Viernes','08:30:00','10:00:00'),
('1CM3','2015-1','C105','118','Viernes','10:30:00','12:00:00'),
---------------------------------------------------------------
---------------------------------------------------------------



('1CM4','2015-1','C106','152','Lunes','07:00:00','08:30:00'),
('1CM4','2015-1','C104','116','Lunes','08:30:00','10:00:00'),
('1CM4','2015-1','C102','123','Lunes','10:30:00','12:00:00'),
('1CM4','2015-1','C105','118','Lunes','12:00:00','13:30:00'),
('1CM4','2015-1','C103','117','Lunes','13:30:00','15:00:00'),
-----------------------------------------------------------
('1CM4','2015-1','C103','117','Martes','07:00:00','08:30:00'),
('1CM4','2015-1','C102','123','Martes','08:30:00','10:00:00'),
('1CM4','2015-1','C111','154','Martes','10:30:00','12:00:00'),
-----------------------------------------------------------
('1CM4','2015-1','C103','117','Miercoles','07:00:00','08:30:00'),
('1CM4','2015-1','C104','116','Miercoles','08:30:00','10:00:00'),
('1CM4','2015-1','C111','154','Miercoles','10:30:00','12:00:00'),
('1CM4','2015-1','C105','118','Miercoles','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM4','2015-1','C106','152','Jueves','07:00:00','08:30:00'),
('1CM4','2015-1','C104','116','Jueves','08:30:00','10:00:00'),
('1CM4','2015-1','C102','123','Jueves','10:30:00','12:00:00'),
('1CM4','2015-1','C105','118','Jueves','12:00:00','13:30:00'),
-------------------------------------------------------------
('1CM4','2015-1','C103','117','Viernes','07:00:00','08:30:00'),
('1CM4','2015-1','C106','152','Viernes','08:30:00','10:00:00'),
('1CM4','2015-1','C111','154','Viernes','10:30:00','12:00:00'),
---------------------------------------------------------------


---------------------------------------------------------------
('1CM5','2015-1','C105','129','Lunes','07:00:00','08:30:00'),
('1CM5','2015-1','C103','117','Lunes','08:30:00','10:00:00'),
('1CM5','2015-1','C104','115','Lunes','10:30:00','12:00:00'),
('1CM5','2015-1','C111','169','Lunes','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM5','2015-1','C106','152','Martes','07:00:00','08:30:00'),
('1CM5','2015-1','C104','115','Martes','08:30:00','10:00:00'),
('1CM5','2015-1','C102','147','Martes','10:30:00','12:00:00'),
-----------------------------------------------------------
('1CM5','2015-1','C106','152','Miercoles','07:00:00','08:30:00'),
('1CM5','2015-1','C103','117','Miercoles','08:30:00','10:00:00'),
('1CM5','2015-1','C102','147','Miercoles','10:30:00','12:00:00'),
('1CM5','2015-1','C111','169','Miercoles','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM5','2015-1','C105','129','Jueves','07:00:00','08:30:00'),
('1CM5','2015-1','C103','117','Jueves','08:30:00','10:00:00'),
('1CM5','2015-1','C104','115','Jueves','10:30:00','12:00:00'),
('1CM5','2015-1','C111','169','Jueves','12:00:00','13:30:00'),
-------------------------------------------------------------
('1CM5','2015-1','C106','152','Viernes','07:00:00','08:30:00'),
('1CM5','2015-1','C105','129','Viernes','08:30:00','10:00:00'),
('1CM5','2015-1','C102','147','Viernes','10:30:00','12:00:00'),
('1CM5','2015-1','C103','117','Viernes','12:00:00','13:30:00'),
---------------------------------------------------------------



---------------------------------------------------------------
('1CM6','2015-1','C111','169','Lunes','07:00:00','08:30:00'),
('1CM6','2015-1','C106','157','Lunes','08:30:00','10:00:00'),
('1CM6','2015-1','C103','110','Lunes','10:30:00','12:00:00'),
('1CM6','2015-1','C102', '147','Lunes','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM6','2015-1','C105','129','Martes','07:00:00','08:30:00'),
('1CM6','2015-1','C103','110','Martes','08:30:00','10:00:00'),
('1CM6','2015-1','C104','115','Martes','10:30:00','12:00:00'),
-----------------------------------------------------------
('1CM6','2015-1','C105','129','Miercoles','07:00:00','08:30:00'),
('1CM6','2015-1','C106','157','Miercoles','08:30:00','10:00:00'),
('1CM6','2015-1','C104','115','Miercoles','10:30:00','12:00:00'),
('1CM6','2015-1','C102','147','Miercoles','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM6','2015-1','C111','169','Jueves','07:00:00','08:30:00'),
('1CM6','2015-1','C106','157','Jueves','08:30:00','10:00:00'),
('1CM6','2015-1','C103','110','Jueves','10:30:00','12:00:00'),
('1CM6','2015-1','C102','147','Jueves','12:00:00','13:30:00'),
-------------------------------------------------------------
('1CM6','2015-1','C105','129','Viernes','07:00:00','08:30:00'),
('1CM6','2015-1','C111','169','Viernes','08:30:00','10:00:00'),
('1CM6','2015-1','C103','110','Viernes','10:30:00','12:00:00'),
('1CM6','2015-1','C104','115','Viernes','12:00:00','13:30:00'),
---------------------------------------------------------------
---------------------------------------------------------------


('1CM7','2015-1','C102','103','Lunes','07:00:00','08:30:00'),
('1CM7','2015-1','C105','149','Lunes','08:30:00','10:00:00'),
('1CM7','2015-1','C106','170','Lunes','10:30:00','12:00:00'),
('1CM7','2015-1','C104','116','Lunes','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM7','2015-1','C111','169','Martes','07:00:00','08:30:00'),
('1CM7','2015-1','C106','170','Martes','08:30:00','10:00:00'),
('1CM7','2015-1','C103','142','Martes','10:30:00','12:00:00'),
-----------------------------------------------------------
('1CM7','2015-1','C111','169','Miercoles','07:00:00','08:30:00'),
('1CM7','2015-1','C105','149','Miercoles','08:30:00','10:00:00'),
('1CM7','2015-1','C103','142','Miercoles','10:30:00','12:00:00'),
('1CM7','2015-1','C104','116','Miercoles','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM7','2015-1','C102','103','Jueves','07:00:00','08:30:00'),
('1CM7','2015-1','C105','149','Jueves','08:30:00','10:00:00'),
('1CM7','2015-1','C103','142','Jueves','12:00:00','13:30:00'),
('1CM7','2015-1','C104','116','Jueves','13:30:00','15:00:00'),
-------------------------------------------------------------
('1CM7','2015-1','C111','169','Viernes','07:00:00','08:30:00'),
('1CM7','2015-1','C102','103','Viernes','08:30:00','10:00:00'),
('1CM7','2015-1','C103','142','Viernes','10:30:00','12:00:00'),
('1CM7','2015-1','C106','170','Viernes','12:00:00','13:30:00'),
---------------------------------------------------------------


---------------------------------------------------------------
('1CM8','2015-1','C104','151','Lunes','07:00:00','08:30:00'),
('1CM8','2015-1','C111','160','Lunes','08:30:00','10:00:00'),
('1CM8','2015-1','C105','109','Lunes','10:30:00','12:00:00'),
('1CM8','2015-1','C103','142','Lunes','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM8','2015-1','C102','123','Martes','07:00:00','08:30:00'),
('1CM8','2015-1','C105','109','Martes','08:30:00','10:00:00'),
('1CM8','2015-1','C106','157','Martes','10:30:00','12:00:00'),
('1CM8','2015-1','C103','142','Martes','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM8','2015-1','C102','123','Miercoles','07:00:00','08:30:00'),
('1CM8','2015-1','C111','160','Miercoles','08:30:00','10:00:00'),
('1CM8','2015-1','C106','157','Miercoles','10:30:00','12:00:00'),
('1CM8','2015-1','C103','142','Miercoles','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM8','2015-1','C104','151','Jueves','07:00:00','08:30:00'),
('1CM8','2015-1','C111','160','Jueves','08:30:00','10:00:00'),
('1CM8','2015-1','C105','109','Jueves','10:30:00','12:00:00'),
('1CM8','2015-1','C103','142','Jueves','12:00:00','13:30:00'),
-------------------------------------------------------------
('1CM8','2015-1','C102','123','Viernes','07:00:00','08:30:00'),
('1CM8','2015-1','C104','151','Viernes','08:30:00','10:00:00'),
('1CM8','2015-1','C106','157','Viernes','10:30:00','12:00:00'),
---------------------------------------------------------------
---------------------------------------------------------------



('1CM9','2015-1','C108','114','Lunes','07:00:00','08:30:00'),
('1CM9','2015-1','C101','145','Lunes','08:30:00','10:00:00'),
('1CM9','2015-1','C109','114','Lunes','10:30:00','12:00:00'),
('1CM9','2015-1','C110','166','Lunes','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM9','2015-1','C112','173','Martes','07:00:00','08:30:00'),
('1CM9','2015-1','C109','114','Martes','08:30:00','10:00:00'),
('1CM9','2015-1','C107','161','Martes','10:30:00','12:00:00'),
-----------------------------------------------------------
('1CM9','2015-1','C112','173','Miercoles','07:00:00','08:30:00'),
('1CM9','2015-1','C101','145','Miercoles','08:30:00','10:00:00'),
('1CM9','2015-1','C107','161','Miercoles','10:30:00','12:00:00'),
('1CM9','2015-1','C110','166','Miercoles','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM9','2015-1','C108','114','Jueves','07:00:00','08:30:00'),
('1CM9','2015-1','C101','145','Jueves','08:30:00','10:00:00'),
('1CM9','2015-1','C109','114','Jueves','10:30:00','12:00:00'),
('1CM9','2015-1','C110','166','Jueves','12:00:00','13:30:00'),
-------------------------------------------------------------
('1CM9','2015-1','C112','173','Viernes','07:00:00','08:30:00'),
('1CM9','2015-1','C108','114','Viernes','08:30:00','10:00:00'),
('1CM9','2015-1','C107','161','Viernes','10:30:00','12:00:00'),
---------------------------------------------------------------


---------------------------------------------------------------
('1CM10','2015-1','C110','167','Lunes','07:00:00','08:30:00'),
('1CM10','2015-1','C112','171','Lunes','08:30:00','10:00:00'),
('1CM10','2015-1','C101','140','Lunes','10:30:00','12:00:00'),
('1CM10','2015-1','C107','108','Lunes','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM10','2015-1','C108','103','Martes','07:00:00','08:30:00'),
('1CM10','2015-1','C101','140','Martes','08:30:00','10:00:00'),
('1CM10','2015-1','C109','124','Martes','10:30:00','12:00:00'),
-----------------------------------------------------------
('1CM10','2015-1','C108','103','Miercoles','07:00:00','08:30:00'),
('1CM10','2015-1','C112','171','Miercoles','08:30:00','10:00:00'),
('1CM10','2015-1','C109','124','Miercoles','10:30:00','12:00:00'),
('1CM10','2015-1','C107','108','Miercoles','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM10','2015-1','C110','167','Jueves','07:00:00','08:30:00'),
('1CM10','2015-1','C112','171','Jueves','08:30:00','10:00:00'),
('1CM10','2015-1','C101','140','Jueves','10:30:00','12:00:00'),
('1CM10','2015-1','C107','108','Jueves','12:00:00','13:30:00'),
-------------------------------------------------------------
('1CM10','2015-1','C108','103','Viernes','07:00:00','08:30:00'),
('1CM10','2015-1','C110','167','Viernes','08:30:00','10:00:00'),
('1CM10','2015-1','C109','124','Viernes','10:30:00','12:00:00'),
---------------------------------------------------------------
---------------------------------------------------------------


('1CM11','2015-1','C107','161','Lunes','07:00:00','08:30:00'),
('1CM11','2015-1','C108','162','Lunes','08:30:00','10:00:00'),
('1CM11','2015-1','C112','173','Lunes','10:30:00','12:00:00'),
('1CM11','2015-1','C109','164','Lunes','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM11','2015-1','C110','167','Martes','07:00:00','08:30:00'),
('1CM11','2015-1','C112','173','Martes','08:30:00','10:00:00'),
('1CM11','2015-1','C101','128','Martes','10:30:00','12:00:00'),
-----------------------------------------------------------
('1CM11','2015-1','C110','167','Miercoles','07:00:00','08:30:00'),
('1CM11','2015-1','C108','162','Miercoles','08:30:00','10:00:00'),
('1CM11','2015-1','C101','128','Miercoles','10:30:00','12:00:00'),
('1CM11','2015-1','C109','164','Miercoles','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM11','2015-1','C107','161','Jueves','07:00:00','08:30:00'),
('1CM11','2015-1','C108','162','Jueves','08:30:00','10:00:00'),
('1CM11','2015-1','C109','164','Jueves','10:30:00','12:00:00'),
('1CM11','2015-1','C112','173','Jueves','12:00:00','13:30:00'),
-------------------------------------------------------------
('1CM11','2015-1','C110','167','Viernes','07:00:00','08:30:00'),
('1CM11','2015-1','C107','161','Viernes','08:30:00','10:00:00'),
('1CM11','2015-1','C101','128','Viernes','10:30:00','12:00:00'),
---------------------------------------------------------------
---------------------------------------------------------------



('1CM12','2015-1','C109','163','Lunes','07:00:00','08:30:00'),
('1CM12','2015-1','C110','165','Lunes','08:30:00','10:00:00'),
('1CM12','2015-1','C108','130','Lunes','10:30:00','12:00:00'),
('1CM12','2015-1','C101','120','Lunes','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM12','2015-1','C108','130','Martes','08:30:00','10:00:00'),
('1CM12','2015-1','C112','173','Martes','10:30:00','12:00:00'),
-----------------------------------------------------------
('1CM12','2015-1','C110','165','Miercoles','08:30:00','10:00:00'),
('1CM12','2015-1','C112','173','Miercoles','10:30:00','12:00:00'),
('1CM12','2015-1','C101','120','Miercoles','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM12','2015-1','C109','163','Jueves','07:00:00','08:30:00'),
('1CM12','2015-1','C110','165','Jueves','08:30:00','10:00:00'),
('1CM12','2015-1','C108','130','Jueves','10:30:00','12:00:00'),
('1CM12','2015-1','C101','120','Jueves','12:00:00','13:30:00'),
-------------------------------------------------------------
('1CM12','2015-1','C109','163','Viernes','08:30:00','10:00:00'),
('1CM12','2015-1','C112','173','Viernes','10:30:00','12:00:00'),
---------------------------------------------------------------
---------------------------------------------------------------



('1CM13','2015-1','C101','158','Lunes','07:00:00','08:30:00'),
('1CM13','2015-1','C107','160','Lunes','08:30:00','10:00:00'),
('1CM13','2015-1','C110','165','Lunes','10:30:00','12:00:00'),
('1CM13','2015-1','C112','172','Lunes','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM13','2015-1','C109','163','Martes','07:00:00','08:30:00'),
('1CM13','2015-1','C110','165','Martes','08:30:00','10:00:00'),
('1CM13','2015-1','C108','114','Martes','10:30:00','12:00:00'),
('1CM13','2015-1','C102','124','Martes','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM13','2015-1','C109','163','Miercoles','07:00:00','08:30:00'),
('1CM13','2015-1','C107','160','Miercoles','08:30:00','10:00:00'),
('1CM13','2015-1','C108','114','Miercoles','10:30:00','12:00:00'),
('1CM13','2015-1','C112','172','Miercoles','12:00:00','13:30:00'),
('1CM13','2015-1','C102','124','Miercoles','13:30:00','15:00:00'),
-----------------------------------------------------------
('1CM13','2015-1','C101','158','Jueves','07:00:00','08:30:00'),
('1CM13','2015-1','C107','160','Jueves','08:30:00','10:00:00'),
('1CM13','2015-1','C110','165','Jueves','10:30:00','12:00:00'),
('1CM13','2015-1','C112','172','Jueves','12:00:00','13:30:00'),
-------------------------------------------------------------
('1CM13','2015-1','C109','163','Viernes','07:00:00','08:30:00'),
('1CM13','2015-1','C101','158','Viernes','08:30:00','10:00:00'),
('1CM13','2015-1','C108','114','Viernes','10:30:00','12:00:00'),
('1CM13','2015-1','C102','124','Viernes','12:00:00','13:30:00'),
--------------------------------------------------------------
--------------------------------------------------------------


('1CM14','2015-1','C104','102','Lunes','07:00:00','08:30:00'),
('1CM14','2015-1','C103','113','Lunes','08:30:00','10:00:00'),
('1CM14','2015-1','C110','116','Lunes','10:30:00','12:00:00'),
('1CM14','2015-1','C108','149','Lunes','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM14','2015-1','C112','172','Martes','07:00:00','08:30:00'),
('1CM14','2015-1','C110','116','Martes','08:30:00','10:00:00'),
('1CM14','2015-1','C105','109','Martes','10:30:00','12:00:00'),
-----------------------------------------------------------
('1CM14','2015-1','C112','172','Miercoles','07:00:00','08:30:00'),
('1CM14','2015-1','C103','113','Miercoles','08:30:00','10:00:00'),
('1CM14','2015-1','C105','109','Miercoles','10:30:00','12:00:00'),
('1CM14','2015-1','C108','149','Miercoles','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM14','2015-1','C104','102','Jueves','07:00:00','08:30:00'),
('1CM14','2015-1','C103','113','Jueves','08:30:00','10:00:00'),
('1CM14','2015-1','C110','116','Jueves','10:30:00','12:00:00'),
('1CM14','2015-1','C108','149','Jueves','12:00:00','13:30:00'),
-------------------------------------------------------------
('1CM14','2015-1','C112','172','Viernes','07:00:00','08:30:00'),
('1CM14','2015-1','C104','102','Viernes','08:30:00','10:00:00'),
('1CM14','2015-1','C105','109','Viernes','10:30:00','12:00:00'),
('1CM14','2015-1','C103','113','Viernes','12:00:00','13:30:00'),
--------------------------------------------------------------
--------------------------------------------------------------


('1CM15','2015-1','C110','168','Lunes','07:00:00','08:30:00'),
('1CM15','2015-1','C109','114','Lunes','08:30:00','10:00:00'),
('1CM15','2015-1','C102','159','Lunes','10:30:00','12:00:00'),
('1CM15','2015-1','C105','101','Lunes','12:00:00','13:30:00'),
('1CM15','2015-1','C103','106','Lunes','13:30:00','12:00:00'),
-----------------------------------------------------------
('1CM15','2015-1','C107','160','Martes','07:00:00','08:30:00'),
('1CM15','2015-1','C102','159','Martes','08:30:00','10:00:00'),
('1CM15','2015-1','C103','106','Martes','10:30:00','12:00:00'),
('1CM15','2015-1','C112','174','Martes','12:00:00','13:30:00'),
-----------------------------------------------------------
('1CM15','2015-1','C107','160','Miercoles','07:00:00','08:30:00'),
('1CM15','2015-1','C109','114','Miercoles','08:30:00','10:00:00'),
('1CM15','2015-1','C103','106','Miercoles','10:30:00','12:00:00'),
('1CM15','2015-1','C105','101','Miercoles','12:00:00','13:30:00'),
('1CM15','2015-1','C112','174','Miercoles','13:30:00','15:00:00'),
-----------------------------------------------------------
('1CM15','2015-1','C110','168','Jueves','07:00:00','08:30:00'),
('1CM15','2015-1','C109','114','Jueves','08:30:00','10:00:00'),
('1CM15','2015-1','C102','159','Jueves','10:30:00','12:00:00'),
('1CM15','2015-1','C105','101','Jueves','12:00:00','13:30:00'),
-------------------------------------------------------------
('1CM15','2015-1','C107','160','Viernes','07:00:00','08:30:00'),
('1CM15','2015-1','C110','168','Viernes','08:30:00','10:00:00'),
('1CM15','2015-1','C103','106','Viernes','10:30:00','12:00:00'),
('1CM15','2015-1','C112','174','Viernes','12:00:00','13:30:00');
--------------------------------------------------------------

/* REGISTROS DE TABLA: RELACION*/ 

INSERT INTO RELACION(NumBoleta, IdGrupo, CicloEscolar, IdMateria, IdMAESTRO, Semestre) VALUES
('2014650500', '1CM1', '2015-1', 'C101', '145', 1),
('2014650500', '1CM1', '2015-1', 'C102', '124', 1),
('2014650500', '1CM1', '2015-1', 'C103', '132', 1),
('2014650500', '1CM1', '2015-1', 'C104', '112', 1),
('2014650500', '1CM1', '2015-1', 'C105', '156', 1),
('2014650500', '1CM1', '2015-1', 'C106', '157', 1),
										 		 
('2014650501', '1CM1', '2015-1', 'C101', '145', 1),
('2014650501', '1CM1', '2015-1', 'C102', '124', 1),
('2014650501', '1CM1', '2015-1', 'C103', '132', 1),
('2014650501', '1CM1', '2015-1', 'C104', '112', 1),
('2014650501', '1CM1', '2015-1', 'C105', '156', 1),
('2014650501', '1CM1', '2015-1', 'C106', '157', 1),
										 		 
('2014650502', '1CM1', '2015-1', 'C101', '145', 1),
('2014650502', '1CM1', '2015-1', 'C102', '124', 1),
('2014650502', '1CM1', '2015-1', 'C103', '132', 1),
('2014650502', '1CM1', '2015-1', 'C104', '112', 1),
('2014650502', '1CM1', '2015-1', 'C105', '156', 1),
('2014650502', '1CM1', '2015-1', 'C106', '157', 1),
										 		 
('2014650503', '1CM1', '2015-1', 'C101', '145', 1),
('2014650503', '1CM1', '2015-1', 'C102', '124', 1),
('2014650503', '1CM1', '2015-1', 'C103', '132', 1),
('2014650503', '1CM1', '2015-1', 'C104', '112', 1),
('2014650503', '1CM1', '2015-1', 'C105', '156', 1),
('2014650503', '1CM1', '2015-1', 'C106', '157', 1),
										 	    
('2014650504', '1CM1', '2015-1', 'C101', '145', 1),
('2014650504', '1CM1', '2015-1', 'C102', '124', 1),
('2014650504', '1CM1', '2015-1', 'C103', '132', 1),
('2014650504', '1CM1', '2015-1', 'C104', '112', 1),
('2014650504', '1CM1', '2015-1', 'C105', '156', 1),
('2014650504', '1CM1', '2015-1', 'C106', '157', 1),
										 	    
('2014650505', '1CM1', '2015-1', 'C101', '145', 1),
('2014650505', '1CM1', '2015-1', 'C102', '124', 1),
('2014650505', '1CM1', '2015-1', 'C103', '132', 1),
('2014650505', '1CM1', '2015-1', 'C104', '112', 1),
('2014650505', '1CM1', '2015-1', 'C105', '156', 1),
('2014650505', '1CM1', '2015-1', 'C106', '157', 1),
										 	    
('2014650506', '1CM1', '2015-1', 'C101', '145', 1),
('2014650506', '1CM1', '2015-1', 'C102', '124', 1),
('2014650506', '1CM1', '2015-1', 'C103', '132', 1),
('2014650506', '1CM1', '2015-1', 'C104', '112', 1),
('2014650506', '1CM1', '2015-1', 'C105', '156', 1),
('2014650506', '1CM1', '2015-1', 'C106', '157', 1),
									 	    
('2014650507', '1CM2', '2015-1', 'C101', '158', 1),
('2014650507', '1CM2', '2015-1', 'C102', '138', 1),
('2014650507', '1CM2', '2015-1', 'C103', '132', 1),
('2014650507', '1CM2', '2015-1', 'C104', '105', 1),
('2014650507', '1CM2', '2015-1', 'C105', '101', 1),
('2014650507', '1CM2', '2015-1', 'C106', '152', 1),

('2014650508', '1CM2', '2015-1', 'C101', '158', 1),
('2014650508', '1CM2', '2015-1', 'C102', '138', 1),
('2014650508', '1CM2', '2015-1', 'C103', '132', 1),
('2014650508', '1CM2', '2015-1', 'C104', '105', 1),
('2014650508', '1CM2', '2015-1', 'C105', '101', 1),
('2014650508', '1CM2', '2015-1', 'C106', '152', 1),

('2014650509', '1CM2', '2015-1', 'C101', '158', 1),
('2014650509', '1CM2', '2015-1', 'C102', '138', 1),
('2014650509', '1CM2', '2015-1', 'C103', '132', 1),
('2014650509', '1CM2', '2015-1', 'C104', '105', 1),
('2014650509', '1CM2', '2015-1', 'C105', '101', 1),
('2014650509', '1CM2', '2015-1', 'C106', '152', 1),

('2014650510', '1CM2', '2015-1', 'C101', '158', 1),
('2014650510', '1CM2', '2015-1', 'C102', '138', 1),
('2014650510', '1CM2', '2015-1', 'C103', '132', 1),
('2014650510', '1CM2', '2015-1', 'C104', '105', 1),
('2014650510', '1CM2', '2015-1', 'C105', '101', 1),
('2014650510', '1CM2', '2015-1', 'C106', '152', 1),

('2014650511', '1CM2', '2015-1', 'C101', '158', 1),
('2014650511', '1CM2', '2015-1', 'C102', '138', 1),
('2014650511', '1CM2', '2015-1', 'C103', '132', 1),
('2014650511', '1CM2', '2015-1', 'C104', '105', 1),
('2014650511', '1CM2', '2015-1', 'C105', '101', 1),
('2014650511', '1CM2', '2015-1', 'C106', '152', 1),

('2014650512', '1CM2', '2015-1', 'C101', '158', 1),
('2014650512', '1CM2', '2015-1', 'C102', '138', 1),
('2014650512', '1CM2', '2015-1', 'C103', '132', 1),
('2014650512', '1CM2', '2015-1', 'C104', '105', 1),
('2014650512', '1CM2', '2015-1', 'C105', '101', 1),
('2014650512', '1CM2', '2015-1', 'C106', '152', 1),

('2014650513', '1CM3', '2015-1', 'C111', '169', 1),
('2014650513', '1CM3', '2015-1', 'C102', '159', 1),
('2014650513', '1CM3', '2015-1', 'C103', '117', 1),
('2014650513', '1CM3', '2015-1', 'C104', '121', 1),
('2014650513', '1CM3', '2015-1', 'C105', '118', 1),
('2014650513', '1CM3', '2015-1', 'C106', '157', 1),

('2014650514', '1CM3', '2015-1', 'C111', '169', 1),
('2014650514', '1CM3', '2015-1', 'C102', '159', 1),
('2014650514', '1CM3', '2015-1', 'C103', '117', 1),
('2014650514', '1CM3', '2015-1', 'C104', '121', 1),
('2014650514', '1CM3', '2015-1', 'C105', '118', 1),
('2014650514', '1CM3', '2015-1', 'C106', '157', 1),

('2014650515', '1CM3', '2015-1', 'C111', '169', 1),
('2014650515', '1CM3', '2015-1', 'C102', '159', 1),
('2014650515', '1CM3', '2015-1', 'C103', '117', 1),
('2014650515', '1CM3', '2015-1', 'C104', '121', 1),
('2014650515', '1CM3', '2015-1', 'C105', '118', 1),
('2014650515', '1CM3', '2015-1', 'C106', '157', 1),

('2014650516', '1CM3', '2015-1', 'C111', '169', 1),
('2014650516', '1CM3', '2015-1', 'C102', '159', 1),
('2014650516', '1CM3', '2015-1', 'C103', '117', 1),
('2014650516', '1CM3', '2015-1', 'C104', '121', 1),
('2014650516', '1CM3', '2015-1', 'C105', '118', 1),
('2014650516', '1CM3', '2015-1', 'C106', '157', 1),

('2014650517', '1CM3', '2015-1', 'C111', '169', 1),
('2014650517', '1CM3', '2015-1', 'C102', '159', 1),
('2014650517', '1CM3', '2015-1', 'C103', '117', 1),
('2014650517', '1CM3', '2015-1', 'C104', '121', 1),
('2014650517', '1CM3', '2015-1', 'C105', '118', 1),
('2014650517', '1CM3', '2015-1', 'C106', '157', 1),

('2014650518', '1CM3', '2015-1', 'C111', '169', 1),
('2014650518', '1CM3', '2015-1', 'C102', '159', 1),
('2014650518', '1CM3', '2015-1', 'C103', '117', 1),
('2014650518', '1CM3', '2015-1', 'C104', '121', 1),
('2014650518', '1CM3', '2015-1', 'C105', '118', 1),
('2014650518', '1CM3', '2015-1', 'C106', '157', 1),

('2014650519', '1CM4', '2015-1', 'C111', '154', 1),
('2014650519', '1CM4', '2015-1', 'C102', '123', 1),
('2014650519', '1CM4', '2015-1', 'C103', '117', 1),
('2014650519', '1CM4', '2015-1', 'C104', '116', 1),
('2014650519', '1CM4', '2015-1', 'C105', '118', 1),
('2014650519', '1CM4', '2015-1', 'C106', '152', 1),

('2014650520', '1CM4', '2015-1', 'C111', '154', 1),
('2014650520', '1CM4', '2015-1', 'C102', '123', 1),
('2014650520', '1CM4', '2015-1', 'C103', '117', 1),
('2014650520', '1CM4', '2015-1', 'C104', '116', 1),
('2014650520', '1CM4', '2015-1', 'C105', '118', 1),
('2014650520', '1CM4', '2015-1', 'C106', '152', 1),

('2014650521', '1CM4', '2015-1', 'C111', '154', 1),
('2014650521', '1CM4', '2015-1', 'C102', '123', 1),
('2014650521', '1CM4', '2015-1', 'C103', '117', 1),
('2014650521', '1CM4', '2015-1', 'C104', '116', 1),
('2014650521', '1CM4', '2015-1', 'C105', '118', 1),
('2014650521', '1CM4', '2015-1', 'C106', '152', 1),

('2014650522', '1CM4', '2015-1', 'C111', '154', 1),
('2014650522', '1CM4', '2015-1', 'C102', '123', 1),
('2014650522', '1CM4', '2015-1', 'C103', '117', 1),
('2014650522', '1CM4', '2015-1', 'C104', '116', 1),
('2014650522', '1CM4', '2015-1', 'C105', '118', 1),
('2014650522', '1CM4', '2015-1', 'C106', '152', 1),

('2014650523', '1CM4', '2015-1', 'C111', '154', 1),
('2014650523', '1CM4', '2015-1', 'C102', '123', 1),
('2014650523', '1CM4', '2015-1', 'C103', '117', 1),
('2014650523', '1CM4', '2015-1', 'C104', '116', 1),
('2014650523', '1CM4', '2015-1', 'C105', '118', 1),
('2014650523', '1CM4', '2015-1', 'C106', '152', 1),

('2014650524', '1CM4', '2015-1', 'C111', '154', 1),
('2014650524', '1CM4', '2015-1', 'C102', '123', 1),
('2014650524', '1CM4', '2015-1', 'C103', '117', 1),
('2014650524', '1CM4', '2015-1', 'C104', '116', 1),
('2014650524', '1CM4', '2015-1', 'C105', '118', 1),
('2014650524', '1CM4', '2015-1', 'C106', '152', 1),

('2014650525', '1CM5', '2015-1', 'C111', '169', 1),
('2014650525', '1CM5', '2015-1', 'C102', '147', 1),
('2014650525', '1CM5', '2015-1', 'C103', '117', 1),
('2014650525', '1CM5', '2015-1', 'C104', '115', 1),
('2014650525', '1CM5', '2015-1', 'C105', '129', 1),
('2014650525', '1CM5', '2015-1', 'C106', '152', 1),

('2014650526', '1CM5', '2015-1', 'C111', '169', 1),
('2014650526', '1CM5', '2015-1', 'C102', '147', 1),
('2014650526', '1CM5', '2015-1', 'C103', '117', 1),
('2014650526', '1CM5', '2015-1', 'C104', '115', 1),
('2014650526', '1CM5', '2015-1', 'C105', '129', 1),
('2014650526', '1CM5', '2015-1', 'C106', '152', 1),

('2014650527', '1CM5', '2015-1', 'C111', '169', 1),
('2014650527', '1CM5', '2015-1', 'C102', '147', 1),
('2014650527', '1CM5', '2015-1', 'C103', '117', 1),
('2014650527', '1CM5', '2015-1', 'C104', '115', 1),
('2014650527', '1CM5', '2015-1', 'C105', '129', 1),
('2014650527', '1CM5', '2015-1', 'C106', '152', 1),

('2014650528', '1CM5', '2015-1', 'C111', '169', 1),
('2014650528', '1CM5', '2015-1', 'C102', '147', 1),
('2014650528', '1CM5', '2015-1', 'C103', '117', 1),
('2014650528', '1CM5', '2015-1', 'C104', '115', 1),
('2014650528', '1CM5', '2015-1', 'C105', '129', 1),
('2014650528', '1CM5', '2015-1', 'C106', '152', 1),

('2014650529', '1CM5', '2015-1', 'C111', '169', 1),
('2014650529', '1CM5', '2015-1', 'C102', '147', 1),
('2014650529', '1CM5', '2015-1', 'C103', '117', 1),
('2014650529', '1CM5', '2015-1', 'C104', '115', 1),
('2014650529', '1CM5', '2015-1', 'C105', '129', 1),
('2014650529', '1CM5', '2015-1', 'C106', '152', 1),

('2014650530', '1CM5', '2015-1', 'C111', '169', 1),
('2014650530', '1CM5', '2015-1', 'C102', '147', 1),
('2014650530', '1CM5', '2015-1', 'C103', '117', 1),
('2014650530', '1CM5', '2015-1', 'C104', '115', 1),
('2014650530', '1CM5', '2015-1', 'C105', '129', 1),
('2014650530', '1CM5', '2015-1', 'C106', '152', 1),

('2014650531', '1CM6', '2015-1', 'C111', '169', 1),
('2014650531', '1CM6', '2015-1', 'C102', '147', 1),
('2014650531', '1CM6', '2015-1', 'C103', '110', 1),
('2014650531', '1CM6', '2015-1', 'C104', '115', 1),
('2014650531', '1CM6', '2015-1', 'C105', '129', 1),
('2014650531', '1CM6', '2015-1', 'C106', '157', 1),

('2014650532', '1CM6', '2015-1', 'C111', '169', 1),
('2014650532', '1CM6', '2015-1', 'C102', '147', 1),
('2014650532', '1CM6', '2015-1', 'C103', '110', 1),
('2014650532', '1CM6', '2015-1', 'C104', '115', 1),
('2014650532', '1CM6', '2015-1', 'C105', '129', 1),
('2014650532', '1CM6', '2015-1', 'C106', '157', 1),

('2014650533', '1CM6', '2015-1', 'C111', '169', 1),
('2014650533', '1CM6', '2015-1', 'C102', '147', 1),
('2014650533', '1CM6', '2015-1', 'C103', '110', 1),
('2014650533', '1CM6', '2015-1', 'C104', '115', 1),
('2014650533', '1CM6', '2015-1', 'C105', '129', 1),
('2014650533', '1CM6', '2015-1', 'C106', '157', 1),

('2014650534', '1CM6', '2015-1', 'C111', '169', 1),
('2014650534', '1CM6', '2015-1', 'C102', '147', 1),
('2014650534', '1CM6', '2015-1', 'C103', '110', 1),
('2014650534', '1CM6', '2015-1', 'C104', '115', 1),
('2014650534', '1CM6', '2015-1', 'C105', '129', 1),
('2014650534', '1CM6', '2015-1', 'C106', '157', 1),

('2014650535', '1CM6', '2015-1', 'C111', '169', 1),
('2014650535', '1CM6', '2015-1', 'C102', '147', 1),
('2014650535', '1CM6', '2015-1', 'C103', '110', 1),
('2014650535', '1CM6', '2015-1', 'C104', '115', 1),
('2014650535', '1CM6', '2015-1', 'C105', '129', 1),
('2014650535', '1CM6', '2015-1', 'C106', '157', 1),

('2014650536', '1CM6', '2015-1', 'C111', '169', 1),
('2014650536', '1CM6', '2015-1', 'C102', '147', 1),
('2014650536', '1CM6', '2015-1', 'C103', '110', 1),
('2014650536', '1CM6', '2015-1', 'C104', '115', 1),
('2014650536', '1CM6', '2015-1', 'C105', '129', 1),
('2014650536', '1CM6', '2015-1', 'C106', '157', 1),

('2014650537', '1CM7', '2015-1', 'C111', '169', 1),
('2014650537', '1CM7', '2015-1', 'C102', '103', 1),
('2014650537', '1CM7', '2015-1', 'C103', '142', 1),
('2014650537', '1CM7', '2015-1', 'C104', '116', 1),
('2014650537', '1CM7', '2015-1', 'C105', '149', 1),
('2014650537', '1CM7', '2015-1', 'C106', '170', 1),

('2014650538', '1CM7', '2015-1', 'C111', '169', 1),
('2014650538', '1CM7', '2015-1', 'C102', '103', 1),
('2014650538', '1CM7', '2015-1', 'C103', '142', 1),
('2014650538', '1CM7', '2015-1', 'C104', '116', 1),
('2014650538', '1CM7', '2015-1', 'C105', '149', 1),
('2014650538', '1CM7', '2015-1', 'C106', '170', 1),

('2014650539', '1CM7', '2015-1', 'C111', '169', 1),
('2014650539', '1CM7', '2015-1', 'C102', '103', 1),
('2014650539', '1CM7', '2015-1', 'C103', '142', 1),
('2014650539', '1CM7', '2015-1', 'C104', '116', 1),
('2014650539', '1CM7', '2015-1', 'C105', '149', 1),
('2014650539', '1CM7', '2015-1', 'C106', '170', 1),

('2014650540', '1CM7', '2015-1', 'C111', '169', 1),
('2014650540', '1CM7', '2015-1', 'C102', '103', 1),
('2014650540', '1CM7', '2015-1', 'C103', '142', 1),
('2014650540', '1CM7', '2015-1', 'C104', '116', 1),
('2014650540', '1CM7', '2015-1', 'C105', '149', 1),
('2014650540', '1CM7', '2015-1', 'C106', '170', 1),

('2014650541', '1CM7', '2015-1', 'C111', '169', 1),
('2014650541', '1CM7', '2015-1', 'C102', '103', 1),
('2014650541', '1CM7', '2015-1', 'C103', '142', 1),
('2014650541', '1CM7', '2015-1', 'C104', '116', 1),
('2014650541', '1CM7', '2015-1', 'C105', '149', 1),
('2014650541', '1CM7', '2015-1', 'C106', '170', 1),

('2014650542', '1CM7', '2015-1', 'C111', '169', 1),
('2014650542', '1CM7', '2015-1', 'C102', '103', 1),
('2014650542', '1CM7', '2015-1', 'C103', '142', 1),
('2014650542', '1CM7', '2015-1', 'C104', '116', 1),
('2014650542', '1CM7', '2015-1', 'C105', '149', 1),
('2014650542', '1CM7', '2015-1', 'C106', '170', 1),

('2014650543', '1CM7', '2015-1', 'C111', '169', 1),
('2014650543', '1CM7', '2015-1', 'C102', '103', 1),
('2014650543', '1CM7', '2015-1', 'C103', '142', 1),
('2014650543', '1CM7', '2015-1', 'C104', '116', 1),
('2014650543', '1CM7', '2015-1', 'C105', '149', 1),
('2014650543', '1CM7', '2015-1', 'C106', '170', 1),

('2014650544', '1CM8', '2015-1', 'C111', '160', 1),
('2014650544', '1CM8', '2015-1', 'C102', '123', 1),
('2014650544', '1CM8', '2015-1', 'C103', '142', 1),
('2014650544', '1CM8', '2015-1', 'C104', '151', 1),
('2014650544', '1CM8', '2015-1', 'C105', '109', 1),
('2014650544', '1CM8', '2015-1', 'C106', '157', 1),

('2014650545', '1CM8', '2015-1', 'C111', '160', 1),
('2014650545', '1CM8', '2015-1', 'C102', '123', 1),
('2014650545', '1CM8', '2015-1', 'C103', '142', 1),
('2014650545', '1CM8', '2015-1', 'C104', '151', 1),
('2014650545', '1CM8', '2015-1', 'C105', '109', 1),
('2014650545', '1CM8', '2015-1', 'C106', '157', 1),

('2014650546', '1CM8', '2015-1', 'C111', '160', 1),
('2014650546', '1CM8', '2015-1', 'C102', '123', 1),
('2014650546', '1CM8', '2015-1', 'C103', '142', 1),
('2014650546', '1CM8', '2015-1', 'C104', '151', 1),
('2014650546', '1CM8', '2015-1', 'C105', '109', 1),
('2014650546', '1CM8', '2015-1', 'C106', '157', 1),

('2014650547', '1CM8', '2015-1', 'C111', '160', 1),
('2014650547', '1CM8', '2015-1', 'C102', '123', 1),
('2014650547', '1CM8', '2015-1', 'C103', '142', 1),
('2014650547', '1CM8', '2015-1', 'C104', '151', 1),
('2014650547', '1CM8', '2015-1', 'C105', '109', 1),
('2014650547', '1CM8', '2015-1', 'C106', '157', 1),

('2014650548', '1CM8', '2015-1', 'C111', '160', 1),
('2014650548', '1CM8', '2015-1', 'C102', '123', 1),
('2014650548', '1CM8', '2015-1', 'C103', '142', 1),
('2014650548', '1CM8', '2015-1', 'C104', '151', 1),
('2014650548', '1CM8', '2015-1', 'C105', '109', 1),
('2014650548', '1CM8', '2015-1', 'C106', '157', 1),

('2014650549', '1CM8', '2015-1', 'C111', '160', 1),
('2014650549', '1CM8', '2015-1', 'C102', '123', 1),
('2014650549', '1CM8', '2015-1', 'C103', '142', 1),
('2014650549', '1CM8', '2015-1', 'C104', '151', 1),
('2014650549', '1CM8', '2015-1', 'C105', '109', 1),
('2014650549', '1CM8', '2015-1', 'C106', '157', 1),

('2014650550', '1CM9', '2015-1', 'C101', '145', 1),
('2014650550', '1CM9', '2015-1', 'C107', '161', 1),
('2014650550', '1CM9', '2015-1', 'C108', '114', 1),
('2014650550', '1CM9', '2015-1', 'C109', '114', 1),
('2014650550', '1CM9', '2015-1', 'C110', '166', 1),
('2014650550', '1CM9', '2015-1', 'C112', '173', 1),

('2014650551', '1CM9', '2015-1', 'C101', '145', 1),
('2014650551', '1CM9', '2015-1', 'C107', '161', 1),
('2014650551', '1CM9', '2015-1', 'C108', '114', 1),
('2014650551', '1CM9', '2015-1', 'C109', '114', 1),
('2014650551', '1CM9', '2015-1', 'C110', '166', 1),
('2014650551', '1CM9', '2015-1', 'C112', '173', 1),

('2014650552', '1CM9', '2015-1', 'C101', '145', 1),
('2014650552', '1CM9', '2015-1', 'C107', '161', 1),
('2014650552', '1CM9', '2015-1', 'C108', '114', 1),
('2014650552', '1CM9', '2015-1', 'C109', '114', 1),
('2014650552', '1CM9', '2015-1', 'C110', '166', 1),
('2014650552', '1CM9', '2015-1', 'C112', '173', 1),

('2014650553', '1CM9', '2015-1', 'C101', '145', 1),
('2014650553', '1CM9', '2015-1', 'C107', '161', 1),
('2014650553', '1CM9', '2015-1', 'C108', '114', 1),
('2014650553', '1CM9', '2015-1', 'C109', '114', 1),
('2014650553', '1CM9', '2015-1', 'C110', '166', 1),
('2014650553', '1CM9', '2015-1', 'C112', '173', 1),

('2014650554', '1CM9', '2015-1', 'C101', '145', 1),
('2014650554', '1CM9', '2015-1', 'C107', '161', 1),
('2014650554', '1CM9', '2015-1', 'C108', '114', 1),
('2014650554', '1CM9', '2015-1', 'C109', '114', 1),
('2014650554', '1CM9', '2015-1', 'C110', '166', 1),
('2014650554', '1CM9', '2015-1', 'C112', '173', 1),

('2014650555', '1CM9', '2015-1', 'C101', '145', 1),
('2014650555', '1CM9', '2015-1', 'C107', '161', 1),
('2014650555', '1CM9', '2015-1', 'C108', '114', 1),
('2014650555', '1CM9', '2015-1', 'C109', '114', 1),
('2014650555', '1CM9', '2015-1', 'C110', '166', 1),
('2014650555', '1CM9', '2015-1', 'C112', '173', 1),

('2014650556', '1CM9', '2015-1', 'C101', '145', 1),
('2014650556', '1CM9', '2015-1', 'C107', '161', 1),
('2014650556', '1CM9', '2015-1', 'C108', '114', 1),
('2014650556', '1CM9', '2015-1', 'C109', '114', 1),
('2014650556', '1CM9', '2015-1', 'C110', '166', 1),
('2014650556', '1CM9', '2015-1', 'C112', '173', 1),

('2014650557', '1CM10','2015-1', 'C101', '140', 1),
('2014650557', '1CM10','2015-1', 'C107', '108', 1),
('2014650557', '1CM10','2015-1', 'C108', '103', 1),
('2014650557', '1CM10','2015-1', 'C109', '124', 1),
('2014650557', '1CM10','2015-1', 'C110', '167', 1),
('2014650557', '1CM10','2015-1', 'C112', '171', 1),

('2014650558', '1CM10','2015-1', 'C101', '140', 1),
('2014650558', '1CM10','2015-1', 'C107', '108', 1),
('2014650558', '1CM10','2015-1', 'C108', '103', 1),
('2014650558', '1CM10','2015-1', 'C109', '124', 1),
('2014650558', '1CM10','2015-1', 'C110', '167', 1),
('2014650558', '1CM10','2015-1', 'C112', '171', 1),

('2014650559', '1CM10','2015-1', 'C101', '140', 1),
('2014650559', '1CM10','2015-1', 'C107', '108', 1),
('2014650559', '1CM10','2015-1', 'C108', '103', 1),
('2014650559', '1CM10','2015-1', 'C109', '124', 1),
('2014650559', '1CM10','2015-1', 'C110', '167', 1),
('2014650559', '1CM10','2015-1', 'C112', '171', 1),

('2014650560', '1CM10','2015-1', 'C101', '140', 1),
('2014650560', '1CM10','2015-1', 'C107', '108', 1),
('2014650560', '1CM10','2015-1', 'C108', '103', 1),
('2014650560', '1CM10','2015-1', 'C109', '124', 1),
('2014650560', '1CM10','2015-1', 'C110', '167', 1),
('2014650560', '1CM10','2015-1', 'C112', '171', 1),

('2014650561', '1CM10','2015-1', 'C101', '140', 1),
('2014650561', '1CM10','2015-1', 'C107', '108', 1),
('2014650561', '1CM10','2015-1', 'C108', '103', 1),
('2014650561', '1CM10','2015-1', 'C109', '124', 1),
('2014650561', '1CM10','2015-1', 'C110', '167', 1),
('2014650561', '1CM10','2015-1', 'C112', '171', 1),

('2014650562', '1CM10','2015-1', 'C101', '140', 1),
('2014650562', '1CM10','2015-1', 'C107', '108', 1),
('2014650562', '1CM10','2015-1', 'C108', '103', 1),
('2014650562', '1CM10','2015-1', 'C109', '124', 1),
('2014650562', '1CM10','2015-1', 'C110', '167', 1),
('2014650562', '1CM10','2015-1', 'C112', '171', 1),

('2014650563', '1CM10','2015-1', 'C101', '140', 1),
('2014650563', '1CM10','2015-1', 'C107', '108', 1),
('2014650563', '1CM10','2015-1', 'C108', '103', 1),
('2014650563', '1CM10','2015-1', 'C109', '124', 1),
('2014650563', '1CM10','2015-1', 'C110', '167', 1),
('2014650563', '1CM10','2015-1', 'C112', '171', 1),

('2014650564', '1CM10','2015-1', 'C101', '140', 1),
('2014650564', '1CM10','2015-1', 'C107', '108', 1),
('2014650564', '1CM10','2015-1', 'C108', '103', 1),
('2014650564', '1CM10','2015-1', 'C109', '124', 1),
('2014650564', '1CM10','2015-1', 'C110', '167', 1),
('2014650564', '1CM10','2015-1', 'C112', '171', 1),

('2014650565', '1CM11', '2015-1', 'C101', '128',1),
('2014650565', '1CM11', '2015-1', 'C107', '161',1),
('2014650565', '1CM11', '2015-1', 'C108', '162',1),
('2014650565', '1CM11', '2015-1', 'C109', '164',1),
('2014650565', '1CM11', '2015-1', 'C110', '167',1),
('2014650565', '1CM11', '2015-1', 'C112', '173',1),

('2014650566', '1CM11', '2015-1', 'C101', '128',1),
('2014650566', '1CM11', '2015-1', 'C107', '161',1),
('2014650566', '1CM11', '2015-1', 'C108', '162',1),
('2014650566', '1CM11', '2015-1', 'C109', '164',1),
('2014650566', '1CM11', '2015-1', 'C110', '167',1),
('2014650566', '1CM11', '2015-1', 'C112', '173',1),

('2014650567', '1CM11', '2015-1', 'C101', '128',1),
('2014650567', '1CM11', '2015-1', 'C107', '161',1),
('2014650567', '1CM11', '2015-1', 'C108', '162',1),
('2014650567', '1CM11', '2015-1', 'C109', '164',1),
('2014650567', '1CM11', '2015-1', 'C110', '167',1),
('2014650567', '1CM11', '2015-1', 'C112', '173',1),

('2014650568', '1CM11', '2015-1', 'C101', '128',1),
('2014650568', '1CM11', '2015-1', 'C107', '161',1),
('2014650568', '1CM11', '2015-1', 'C108', '162',1),
('2014650568', '1CM11', '2015-1', 'C109', '164',1),
('2014650568', '1CM11', '2015-1', 'C110', '167',1),
('2014650568', '1CM11', '2015-1', 'C112', '173',1),

('2014650569', '1CM11', '2015-1', 'C101', '128',1),
('2014650569', '1CM11', '2015-1', 'C107', '161',1),
('2014650569', '1CM11', '2015-1', 'C108', '162',1),
('2014650569', '1CM11', '2015-1', 'C109', '164',1),
('2014650569', '1CM11', '2015-1', 'C110', '167',1),
('2014650569', '1CM11', '2015-1', 'C112', '173',1),

('2014650570', '1CM11', '2015-1', 'C101', '128',1),
('2014650570', '1CM11', '2015-1', 'C107', '161',1),
('2014650570', '1CM11', '2015-1', 'C108', '162',1),
('2014650570', '1CM11', '2015-1', 'C109', '164',1),
('2014650570', '1CM11', '2015-1', 'C110', '167',1),
('2014650570', '1CM11', '2015-1', 'C112', '173',1),

('2014650571', '1CM11', '2015-1', 'C101', '128',1),
('2014650571', '1CM11', '2015-1', 'C107', '161',1),
('2014650571', '1CM11', '2015-1', 'C108', '162',1),
('2014650571', '1CM11', '2015-1', 'C109', '164',1),
('2014650571', '1CM11', '2015-1', 'C110', '167',1),
('2014650571', '1CM11', '2015-1', 'C112', '173',1),

('2014650572', '1CM12', '2015-1', 'C101', '120',1),
('2014650572', '1CM12', '2015-1', 'C108', '130',1),
('2014650572', '1CM12', '2015-1', 'C109', '163',1),
('2014650572', '1CM12', '2015-1', 'C110', '165',1),
('2014650572', '1CM12', '2015-1', 'C112', '173',1),

('2014650573', '1CM12', '2015-1', 'C101', '120',1),
('2014650573', '1CM12', '2015-1', 'C108', '130',1),
('2014650573', '1CM12', '2015-1', 'C109', '163',1),
('2014650573', '1CM12', '2015-1', 'C110', '165',1),
('2014650573', '1CM12', '2015-1', 'C112', '173',1),

('2014650574', '1CM12', '2015-1', 'C101', '120',1),
('2014650574', '1CM12', '2015-1', 'C108', '130',1),
('2014650574', '1CM12', '2015-1', 'C109', '163',1),
('2014650574', '1CM12', '2015-1', 'C110', '165',1),
('2014650574', '1CM12', '2015-1', 'C112', '173',1),

('2014650575', '1CM12', '2015-1', 'C101', '120',1),
('2014650575', '1CM12', '2015-1', 'C108', '130',1),
('2014650575', '1CM12', '2015-1', 'C109', '163',1),
('2014650575', '1CM12', '2015-1', 'C110', '165',1),
('2014650575', '1CM12', '2015-1', 'C112', '173',1),

('2014650576', '1CM12', '2015-1', 'C101', '120',1),
('2014650576', '1CM12', '2015-1', 'C108', '130',1),
('2014650576', '1CM12', '2015-1', 'C109', '163',1),
('2014650576', '1CM12', '2015-1', 'C110', '165',1),
('2014650576', '1CM12', '2015-1', 'C112', '173',1),

('2014650577', '1CM12', '2015-1', 'C101', '120',1),
('2014650577', '1CM12', '2015-1', 'C108', '130',1),
('2014650577', '1CM12', '2015-1', 'C109', '163',1),
('2014650577', '1CM12', '2015-1', 'C110', '165',1),
('2014650577', '1CM12', '2015-1', 'C112', '173',1),

('2014650578', '1CM12', '2015-1', 'C101', '120',1),
('2014650578', '1CM12', '2015-1', 'C108', '130',1),
('2014650578', '1CM12', '2015-1', 'C109', '163',1),
('2014650578', '1CM12', '2015-1', 'C110', '165',1),
('2014650578', '1CM12', '2015-1', 'C112', '173',1),

('2014650579', '1CM13', '2015-1', 'C101', '158',1),
('2014650579', '1CM13', '2015-1', 'C102', '124',1),
('2014650579', '1CM13', '2015-1', 'C107', '160',1),
('2014650579', '1CM13', '2015-1', 'C108', '114',1),
('2014650579', '1CM13', '2015-1', 'C109', '163',1),
('2014650579', '1CM13', '2015-1', 'C110', '165',1),
('2014650579', '1CM13', '2015-1', 'C112', '172',1),

('2014650580', '1CM13', '2015-1', 'C101', '158',1),
('2014650580', '1CM13', '2015-1', 'C102', '124',1),
('2014650580', '1CM13', '2015-1', 'C107', '160',1),
('2014650580', '1CM13', '2015-1', 'C108', '114',1),
('2014650580', '1CM13', '2015-1', 'C109', '163',1),
('2014650580', '1CM13', '2015-1', 'C110', '165',1),
('2014650580', '1CM13', '2015-1', 'C112', '172',1),


('2014650581', '1CM13', '2015-1', 'C101', '158',1),
('2014650581', '1CM13', '2015-1', 'C102', '124',1),
('2014650581', '1CM13', '2015-1', 'C107', '160',1),
('2014650581', '1CM13', '2015-1', 'C108', '114',1),
('2014650581', '1CM13', '2015-1', 'C109', '163',1),
('2014650581', '1CM13', '2015-1', 'C110', '165',1),
('2014650581', '1CM13', '2015-1', 'C112', '172',1),


('2014650582', '1CM13', '2015-1', 'C101', '158',1),
('2014650582', '1CM13', '2015-1', 'C102', '124',1),
('2014650582', '1CM13', '2015-1', 'C107', '160',1),
('2014650582', '1CM13', '2015-1', 'C108', '114',1),
('2014650582', '1CM13', '2015-1', 'C109', '163',1),
('2014650582', '1CM13', '2015-1', 'C110', '165',1),
('2014650582', '1CM13', '2015-1', 'C112', '172',1),


('2014650583', '1CM13', '2015-1', 'C101', '158',1),
('2014650583', '1CM13', '2015-1', 'C102', '124',1),
('2014650583', '1CM13', '2015-1', 'C107', '160',1),
('2014650583', '1CM13', '2015-1', 'C108', '114',1),
('2014650583', '1CM13', '2015-1', 'C109', '163',1),
('2014650583', '1CM13', '2015-1', 'C110', '165',1),
('2014650583', '1CM13', '2015-1', 'C112', '172',1),


('2014650584', '1CM13', '2015-1', 'C101', '158',1),
('2014650584', '1CM13', '2015-1', 'C102', '124',1),
('2014650584', '1CM13', '2015-1', 'C107', '160',1),
('2014650584', '1CM13', '2015-1', 'C108', '114',1),
('2014650584', '1CM13', '2015-1', 'C109', '163',1),
('2014650584', '1CM13', '2015-1', 'C110', '165',1),
('2014650584', '1CM13', '2015-1', 'C112', '172',1),

('2014650585', '1CM13', '2015-1', 'C101', '158',1),
('2014650585', '1CM13', '2015-1', 'C102', '124',1),
('2014650585', '1CM13', '2015-1', 'C107', '160',1),
('2014650585', '1CM13', '2015-1', 'C108', '114',1),
('2014650585', '1CM13', '2015-1', 'C109', '163',1),
('2014650585', '1CM13', '2015-1', 'C110', '165',1),
('2014650585', '1CM13', '2015-1', 'C112', '172',1),

('2014650586', '1CM14', '2015-1', 'C103', '113',1),
('2014650586', '1CM14', '2015-1', 'C104', '102',1),
('2014650586', '1CM14', '2015-1', 'C105', '109',1),
('2014650586', '1CM14', '2015-1', 'C108', '149',1),
('2014650586', '1CM14', '2015-1', 'C110', '116',1),
('2014650586', '1CM14', '2015-1', 'C112', '172',1),

('2014650587', '1CM14', '2015-1', 'C103', '113',1),
('2014650587', '1CM14', '2015-1', 'C104', '102',1),
('2014650587', '1CM14', '2015-1', 'C105', '109',1),
('2014650587', '1CM14', '2015-1', 'C108', '149',1),
('2014650587', '1CM14', '2015-1', 'C110', '116',1),
('2014650587', '1CM14', '2015-1', 'C112', '172',1),

('2014650588', '1CM14', '2015-1', 'C103', '113',1),
('2014650588', '1CM14', '2015-1', 'C104', '102',1),
('2014650588', '1CM14', '2015-1', 'C105', '109',1),
('2014650588', '1CM14', '2015-1', 'C108', '149',1),
('2014650588', '1CM14', '2015-1', 'C110', '116',1),
('2014650588', '1CM14', '2015-1', 'C112', '172',1),

('2014650589', '1CM14', '2015-1', 'C103', '113',1),
('2014650589', '1CM14', '2015-1', 'C104', '102',1),
('2014650589', '1CM14', '2015-1', 'C105', '109',1),
('2014650589', '1CM14', '2015-1', 'C108', '149',1),
('2014650589', '1CM14', '2015-1', 'C110', '116',1),
('2014650589', '1CM14', '2015-1', 'C112', '172',1),

('2014650590', '1CM14', '2015-1', 'C103', '113',1),
('2014650590', '1CM14', '2015-1', 'C104', '102',1),
('2014650590', '1CM14', '2015-1', 'C105', '109',1),
('2014650590', '1CM14', '2015-1', 'C108', '149',1),
('2014650590', '1CM14', '2015-1', 'C110', '116',1),
('2014650590', '1CM14', '2015-1', 'C112', '172',1),

('2014650591', '1CM14', '2015-1', 'C103', '113',1),
('2014650591', '1CM14', '2015-1', 'C104', '102',1),
('2014650591', '1CM14', '2015-1', 'C105', '109',1),
('2014650591', '1CM14', '2015-1', 'C108', '149',1),
('2014650591', '1CM14', '2015-1', 'C110', '116',1),
('2014650591', '1CM14', '2015-1', 'C112', '172',1),

('2014650592', '1CM14', '2015-1', 'C103', '113',1),
('2014650592', '1CM14', '2015-1', 'C104', '102',1),
('2014650592', '1CM14', '2015-1', 'C105', '109',1),
('2014650592', '1CM14', '2015-1', 'C108', '149',1),
('2014650592', '1CM14', '2015-1', 'C110', '116',1),
('2014650592', '1CM14', '2015-1', 'C112', '172',1),

('2014650593', '1CM15', '2015-1', 'C102', '159',1),
('2014650593', '1CM15', '2015-1', 'C103', '106',1),
('2014650593', '1CM15', '2015-1', 'C105', '101',1),
('2014650593', '1CM15', '2015-1', 'C107', '160',1),
('2014650593', '1CM15', '2015-1', 'C109', '114',1),
('2014650593', '1CM15', '2015-1', 'C110', '168',1),
('2014650593', '1CM15', '2015-1', 'C112', '174',1),

('2014650594', '1CM15', '2015-1', 'C102', '159',1),
('2014650594', '1CM15', '2015-1', 'C103', '106',1),
('2014650594', '1CM15', '2015-1', 'C105', '101',1),
('2014650594', '1CM15', '2015-1', 'C107', '160',1),
('2014650594', '1CM15', '2015-1', 'C109', '114',1),
('2014650594', '1CM15', '2015-1', 'C110', '168',1),
('2014650594', '1CM15', '2015-1', 'C112', '174',1),

('2014650595', '1CM15', '2015-1', 'C102', '159',1),
('2014650595', '1CM15', '2015-1', 'C103', '106',1),
('2014650595', '1CM15', '2015-1', 'C105', '101',1),
('2014650595', '1CM15', '2015-1', 'C107', '160',1),
('2014650595', '1CM15', '2015-1', 'C109', '114',1),
('2014650595', '1CM15', '2015-1', 'C110', '168',1),
('2014650595', '1CM15', '2015-1', 'C112', '174',1),

('2014650596', '1CM15', '2015-1', 'C102', '159',1),
('2014650596', '1CM15', '2015-1', 'C103', '106',1),
('2014650596', '1CM15', '2015-1', 'C105', '101',1),
('2014650596', '1CM15', '2015-1', 'C107', '160',1),
('2014650596', '1CM15', '2015-1', 'C109', '114',1),
('2014650596', '1CM15', '2015-1', 'C110', '168',1),
('2014650596', '1CM15', '2015-1', 'C112', '174',1),

('2014650597', '1CM15', '2015-1', 'C102', '159',1),
('2014650597', '1CM15', '2015-1', 'C103', '106',1),
('2014650597', '1CM15', '2015-1', 'C105', '101',1),
('2014650597', '1CM15', '2015-1', 'C107', '160',1),
('2014650597', '1CM15', '2015-1', 'C109', '114',1),
('2014650597', '1CM15', '2015-1', 'C110', '168',1),
('2014650597', '1CM15', '2015-1', 'C112', '174',1),

('2014650598', '1CM15', '2015-1', 'C102', '159',1),
('2014650598', '1CM15', '2015-1', 'C103', '106',1),
('2014650598', '1CM15', '2015-1', 'C105', '101',1),
('2014650598', '1CM15', '2015-1', 'C107', '160',1),
('2014650598', '1CM15', '2015-1', 'C109', '114',1),
('2014650598', '1CM15', '2015-1', 'C110', '168',1),
('2014650598', '1CM15', '2015-1', 'C112', '174',1),

('2014650599', '1CM15', '2015-1', 'C102', '159',1),
('2014650599', '1CM15', '2015-1', 'C103', '106',1),
('2014650599', '1CM15', '2015-1', 'C105', '101',1),
('2014650599', '1CM15', '2015-1', 'C107', '160',1),
('2014650599', '1CM15', '2015-1', 'C109', '114',1),
('2014650599', '1CM15', '2015-1', 'C110', '168',1),
('2014650599', '1CM15', '2015-1', 'C112', '174',1);


/*INGRESAR Calificacion Y FormaAprobacion DE LA TABLA RELACION A
TODOS LOS ESTUDIANTES EN ALGUNA DE SUS MATERIAS POR GRUPO*/

--Grupo 1CM1 en la materia de Análisis Vectorial
UPDATE RELACION SET Calificacion = 8, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650500' AND IdMateria = 'C101';
UPDATE RELACION SET Calificacion = 6, FormaAprobacion = 'EXT' WHERE NumBoleta = '2014650501' AND IdMateria = 'C101';
UPDATE RELACION SET Calificacion = 6, FormaAprobacion = 'EXT' WHERE NumBoleta = '2014650502' AND IdMateria = 'C101';
UPDATE RELACION SET Calificacion = 9, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650503' AND IdMateria = 'C101';
UPDATE RELACION SET Calificacion = 7, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650504' AND IdMateria = 'C101';
UPDATE RELACION SET Calificacion = 7, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650505' AND IdMateria = 'C101';
UPDATE RELACION SET Calificacion = 7, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650506' AND IdMateria = 'C101';

--Grupo 1CM2 en la materia de Análisis Vectorial
UPDATE RELACION SET Calificacion = 5 WHERE NumBoleta = '2014650507' AND IdMateria = 'C101';
UPDATE RELACION SET Calificacion = 6, FormaAprobacion = 'EXT' WHERE NumBoleta = '2014650508' AND IdMateria = 'C101';
UPDATE RELACION SET Calificacion = 7, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650509' AND IdMateria = 'C101';
UPDATE RELACION SET Calificacion = 7, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650510' AND IdMateria = 'C101';
UPDATE RELACION SET Calificacion = 8, FormaAprobacion = 'EXT' WHERE NumBoleta = '2014650511' AND IdMateria = 'C101';
UPDATE RELACION SET Calificacion = 9, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650512' AND IdMateria = 'C101';
UPDATE RELACION SET Calificacion = 4 WHERE NumBoleta = '2014650513' AND IdMateria = 'C101';

--Grupo 1CM3 en la materia de Matemáticas discretas
UPDATE RELACION SET Calificacion = 6, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650513' AND IdMateria = 'C103';
UPDATE RELACION SET Calificacion = 5 WHERE NumBoleta = '2014650514' AND IdMateria = 'C103';
UPDATE RELACION SET Calificacion = 7, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650515' AND IdMateria = 'C103';
UPDATE RELACION SET Calificacion = 8, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650516' AND IdMateria = 'C103';
UPDATE RELACION SET Calificacion = 4  WHERE NumBoleta = '2014650517' AND IdMateria = 'C103';
UPDATE RELACION SET Calificacion = 9, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650518' AND IdMateria = 'C103';

--Grupo 1CM5 en la materia de Cálculo
UPDATE RELACION SET Calificacion = 6, FormaAprobacion = 'EXT' WHERE NumBoleta = '2014650525' AND IdMateria = 'C102';
UPDATE RELACION SET Calificacion = 7, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650526' AND IdMateria = 'C102';
UPDATE RELACION SET Calificacion = 7, FormaAprobacion = 'EXT' WHERE NumBoleta = '2014650527' AND IdMateria = 'C102';
UPDATE RELACION SET Calificacion = 8, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650528' AND IdMateria = 'C102';
UPDATE RELACION SET Calificacion = 8, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650529' AND IdMateria = 'C102';
UPDATE RELACION SET Calificacion = 9, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650530' AND IdMateria = 'C102';

--Grupo 1CM7 en la materia de Algoritmia y programación estructurada
UPDATE RELACION SET Calificacion = 7, FormaAprobacion = 'EXT' WHERE NumBoleta = '2014650537' AND IdMateria = 'C104';
UPDATE RELACION SET Calificacion = 8, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650538' AND IdMateria = 'C104';
UPDATE RELACION SET Calificacion = 8, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650539' AND IdMateria = 'C104';
UPDATE RELACION SET Calificacion = 9, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650540' AND IdMateria = 'C104';
UPDATE RELACION SET Calificacion = 9, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650541' AND IdMateria = 'C104';
UPDATE RELACION SET Calificacion = 9, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650542' AND IdMateria = 'C104';
UPDATE RELACION SET Calificacion = 9, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650543' AND IdMateria = 'C104';

--Grupo 1CM9 en la materia de Análisis Vectorial
UPDATE RELACION SET Calificacion = 8, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650550' AND IdMateria = 'C101';
UPDATE RELACION SET Calificacion = 6, FormaAprobacion = 'EXT' WHERE NumBoleta = '2014650551' AND IdMateria = 'C101';
UPDATE RELACION SET Calificacion = 7, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650552' AND IdMateria = 'C101';
UPDATE RELACION SET Calificacion = 6, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650553' AND IdMateria = 'C101';
UPDATE RELACION SET Calificacion = 4 WHERE NumBoleta = '2014650554' AND IdMateria = 'C101';
UPDATE RELACION SET Calificacion = 6, FormaAprobacion = 'EXT' WHERE NumBoleta = '2014650555' AND IdMateria = 'C101';
UPDATE RELACION SET Calificacion = 7, FormaAprobacion = 'ORD' WHERE NumBoleta = '2014650556' AND IdMateria = 'C101';