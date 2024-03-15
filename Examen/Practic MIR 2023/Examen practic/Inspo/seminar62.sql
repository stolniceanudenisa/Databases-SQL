create database CFR;

go 
use CFR 

create table TipTren
(id int primary key,
nume varchar(50)
)

create table Tren 
(id int primary key, 
nume varchar(50),
tip int foreign key references TipTren(id)
)

create table Rute
( id int primary key,
nume varchar(50),
tren int foreign key references Tren(id) on delete cascade on update cascade
)

create table Statii
(id int primary key,
nume varchar(50)
)

create table Rute_Statii
(ruta int foreign key references Rute(id) on delete cascade on update cascade,
statie int foreign key references Statii(id) on delete cascade on update cascade,
oras time(0),
orap time(0),
constraint pk_Rute_Statii primary key(ruta,statie)
)

insert into TipTren values (1, 'Inter Regio')

insert into Tren values (1,'tren1', 1)

insert into Rute values (1,'Cluj-Iasi', 1)

insert into Statii values 
(1, 'Cluj-Napoca'),
(2, 'Apahida'),
(3, 'Beclean'),
(4, 'Bistrita'),
(5, 'Vatra Dornei'),
(6, 'Suceava'),
(7, 'Iasi');

insert into Rute_Statii values
(1,1, '12:00:00', '12:30:00'),
(1,2, '13:00:00', '13:30:00'),
(1,3, '15:00:00', '15:30:00'),
(1,4, '17:00:00', '17:30:00');


create procedure adaugaruteStatii(@ruta int, @statia int, @oras time, @orap time)
as
begin

declare @n int
set @n = 0
select @n = COUNT(*) from Rute_Statii where ruta = @ruta and statie = @statia

--presupunem ca @ruta exista in tabela Rute si @statia exista in tabela Statii
if @n <> 0 
begin
 update Rute_Statii set oras = @oras, orap = @orap
 where ruta = @ruta and statie = @statia
 end
 else
 begin
 insert into Rute_Statii values (@ruta, @statia, @oras, @orap)
end
end


exec adaugaruteStatii 1,5,'19:00:00', '19:15:00'
exec adaugaruteStatii 1,6,'20:00:00', '20:15:00'
exec adaugaruteStatii 1,7,'20:00:00', '20:15:00'



--creati un view care afiseaza numele rutelor care contin toate statiile

create view nrStatii as
select r.id from Rute r inner join Rute_Statii rs on
r.id = rs.ruta
group by r.id
having COUNT(*) = (select COUNT(*) from Statii)

select * from nrStatii


--creati o functie care afiseaza toate statiile care au mai mult de un tren la un anumit moment din zi

create function f() returns table as return
select distinct s.nume from Statii s inner join Rute_Statii rs1
on s.id  = rs1.statie inner join Rute_Statii rs2
on rs1.statie = rs2.statie and rs1.ruta <> rs2.ruta

where (rs1.oras <= rs2.oras and rs2.oras <= rs1.orap ) or
(rs1.oras <= rs2.orap and rs2.orap <= rs1.orap)

select * from f()

insert into Tren values(2,'tren2',1)
insert into Rute values(2, 'Cluj-Suceava',2)
insert into Rute_Statii values(2,6,'20:05:00', '20:20:00')
