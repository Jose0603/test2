--Ejercicio 1 del Examen
--creacion de function con 2 variables el maximo y el random
alter function Ejercicio1Examen(@Maximo int,@rand1 float)
returns varchar(500)
begin
--declaracion de variables siendo var1 lo q retorno, rand2 como variable con valor aletorio por el maximo
--variable de arriba y abajo con su id y el porcentaje
declare @var1 varchar(500),@rand2 float,@arriba float,@abajo float,@idarriba varchar(10),@idabajo varchar(10),@porcentaje float
--llenamos rand2
	select @rand2=@Maximo*@rand1
--seleccionamos el q valor q esta arriba y abajo de nuestro random
	Select @arriba=Min(DataLog2.Value) from DataLog2 where DataLog2.Value > @rand2
	select @idarriba=DataLog2.ID from DataLog2 where DataLog2.Value=@arriba
	Select @abajo=Max(DataLog2.Value) from DataLog2 where DataLog2.Value < @rand2
	select @idabajo=DataLog2.ID from DataLog2 where DataLog2.Value=@abajo
--con resta comprobamos cual es el menor ya que el menor esta cerca del random
	select @var1=case when (@arriba-@rand2)<(@abajo-@rand2) then @idarriba
	 else @idabajo end
--llenamos la variable porcentaje
	select @porcentaje=DataLog2.Value from DataLog2 where DataLog2.ID=@var1
	select @porcentaje=(@rand2/@porcentaje)*100
--retornamos el valor de var1 concatenado con el porcentaje
return @var1+'         '+cast(@porcentaje as varchar)+'%'
end
go
select dbo.Ejercicio1Examen(91,rand()) as 'ID'
go

--Ejercicio #2
--creamos trigger
Create trigger Tri ON source after update as 
begin 
set NOCOUNT on; 
--razon que lo dispara
IF( UPDATE (TimeZoneID)) 
BEGIN 
--declaracion de variables
Declare @A int, @B int 
--la constante se encuentra aqui
Set @A = (select TimeZoneID from deleted ) 
--solo para demostrar que si le preste atencion tambien 
Set  @B = (select TimeZoneID from inserted) 
select DisplayName from TimeZone where (TimeZone.ID=@A) update DataLog2 
--lo concetamos con un inner join
set TimestampUTC=Dateadd(Hour,@B-@A,TimestampUTC) From DataLog2 inner join Source on DataLog2.SourceID=Source.ID 
inner join TimeZone on Source.TimeZoneID=TimeZone.ID 
 END
END