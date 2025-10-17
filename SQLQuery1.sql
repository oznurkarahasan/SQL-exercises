--urun.kategori id foreign key her ürünün sadece bir kategorisi olabilir

--1.soru:Devrek maðazasýndan ürün kategorisi Buzdolabý olan ürünlerden alan müþterilerin adý, soyadý, telefon numarasý, adresi, ürün adý 
--ve sipariþ tarihini, sipariþ tarihi yeniden eskiye doðru sýralanmýþ þekilde listeleyiniz?
select m.adi,m.soyadi,m.telefon,m.adres, u.urun_adi, s.siparis_tarihi from siparis_detay sd
inner join siparis s
on sd.siparis_id = s.siparis_id
inner join musteri m
on s.musteri_id = m.musteri_id
inner join urun u
on sd.urun_id = u.urun_id
inner join kategori k
on u.kategori_id = k.kategori_id
inner join sube sb
on s.sube_id = sb.sube_id
where sb.sube_adi = 'Devrek' and kategori = 'Buzdolabý' order by s.siparis_tarihi desc




--2.soru:Mayýs ayý içerisinde Kozlu maðazasýndan “Set Üstü Ocak” kategorisinde ürün alan müþterilerin adý, soyadý, ürün adý, ürün fiyatý bilgilerini listeleyiniz? 
select m.adi,m.soyadi,u.urun_adi, u.fiyat from siparis_detay sd
inner join siparis s
on sd.siparis_id = s.siparis_id
inner join musteri m
on s.musteri_id = m.musteri_id
inner join urun u
on sd.urun_id = u.urun_id
inner join kategori k
on u.kategori_id = k.kategori_id
inner join sube sb
on s.sube_id = sb.sube_id
where month(s.siparis_tarihi) = 05 and sb.sube_adi = 'Kozlu' and k.kategori = 'Set Üstü Ocak'



--3.soru:Ereðli, Devrek ya da Çaycuma þubelerinden gönderi türü “Maðazadan Teslim” þeklinde ürün alan müþteri adý, soyadý, adresi, 
--mesleði, ürün adý, ürün fiyatý ve Sipariþi alan personelin adý, soyadý , þube adý ve gonderi türü  bilgilerini listeleyiniz? 
select m.adi, m.soyadi, m.adres, ms.meslek, u.urun_adi, u.fiyat, p.adi as 'Personel Adý', p.soyadi as 'Personel Soyadý', sb.sube_adi, g.gonderi_turu  from siparis_detay sd
inner join siparis s
on sd.siparis_id = s.siparis_id
inner join musteri m
on s.musteri_id = m.musteri_id
inner join urun u
on sd.urun_id = u.urun_id
inner join kategori k
on u.kategori_id = k.kategori_id
inner join sube sb
on s.sube_id = sb.sube_id
inner join gonderi g
on s.gonderi_id = g.gonderi_id
inner join meslek ms
on m.meslek_id = ms.meslek_id
inner join personel p
on s.personel_id = p.id
where (sb.sube_adi = 'Ereðli' or sb.sube_adi = 'Devrek' or sb.sube_adi = 'Çaycuma' ) and g.gonderi_turu = 'Maðazadan Teslim'




--4.soru: Kilimli þubesinde satýlan toplam Buzdolabý, Ütü, Mikser ya da Su Isýtýcý kategorisindeki ürün sayýsýný bulunuz? 
select sum(sd.adet) as 'Satýlan toplam ürün sayýsý' from siparis_detay sd
inner join siparis s
on sd.siparis_id = s.siparis_id
inner join urun u
on sd.urun_id = u.urun_id
inner join kategori k
on u.kategori_id = k.kategori_id
inner join sube sb
on s.sube_id = sb.sube_id
where sb.sube_adi = 'Kilimli' and (k.kategori = 'Buzdolabý' or k.kategori = 'Ütü' or k.kategori = 'Mikser' or k.kategori = 'Su Isýtýcý')


--5.soru:Çaycuma maðazasýnda Mart- Haziran arasý (Mart, Haziran dahil) 4 ayda adet olarak en çok satýlan ürünün adýný ve Satýþ Adedini bulunuz. 
select top 1 u.urun_adi, sum(sd.adet) as 'Satýþ Adedi' from siparis_detay sd
inner join siparis s
on sd.siparis_id = s.siparis_id
inner join urun u
on sd.urun_id = u.urun_id
inner join kategori k
on u.kategori_id = k.kategori_id
inner join sube sb
on s.sube_id = sb.sube_id
where sb.sube_adi = 'Çaycuma' and month(s.siparis_tarihi) between 3 and 6
group by u.urun_adi
order by [Satýþ Adedi] desc




--6.soru:Kozlu maðazasýnda parasal miktar olarak en fazla satýþ yapan personelin adýný, soyadýný, ve satýþ miktarýný listeleyiniz? 
select top 1 p.adi, p.soyadi, sum(u.fiyat*sd.adet) as 'Satýþ Miktarý' from siparis_detay sd
inner join siparis s
on sd.siparis_id = s.siparis_id
inner join musteri m 
on s.musteri_id = m.musteri_id
inner join urun u
on sd.urun_id = u.urun_id
inner join kategori k
on u.kategori_id = k.kategori_id
inner join sube sb
on s.sube_id = sb.sube_id
inner join personel p
on s.personel_id = p.id
where sb.sube_adi = 'Kozlu' 
group by p.adi, p.soyadi
order by [Satýþ Miktarý] desc



--7.soru:Merkez, Kozlu, Kilimli ve Devrek maðazalarýnda satýlan Buzdolabý kategorisindeki ürün sayýsýný bulunuz? 
select sum(sd.adet) as 'Satýlan toplam ürün sayýsý'  from siparis_detay sd
inner join siparis s
on sd.siparis_id = s.siparis_id
inner join musteri m
on s.musteri_id = m.musteri_id
inner join urun u
on sd.urun_id = u.urun_id
inner join kategori k
on u.kategori_id = k.kategori_id
inner join sube sb
on s.sube_id = sb.sube_id
where sb.sube_adi in ('Merkez', 'Kozlu', 'Kilimli' , 'Devrek') and k.kategori = 'Buzdolabý'



--8.soru:“SALÝH UZUN” isimli müþterinin aldýðý ürünlerin;  ürün adý, kategori, ürün adedi, ürün fiyatlarý, tutarlarýný ve sipariþ tarihlerini sipariþ tarihi yeniden eskiye doðru  listeleyiniz? 
select u.urun_adi, k.kategori, sd.adet, u.fiyat, (sd.adet*u.fiyat) as 'Tutar', s.siparis_tarihi from siparis_detay sd
inner join siparis s
on sd.siparis_id = s.siparis_id
inner join musteri m
on s.musteri_id = m.musteri_id
inner join urun u
on sd.urun_id = u.urun_id
inner join kategori k
on u.kategori_id = k.kategori_id
inner join sube sb
on s.sube_id = sb.sube_id
where m.adi = 'SALÝH' and m.soyadi='UZUN' 
order by s.siparis_tarihi desc



--9.soru:Merkez þubesinden parasal tutar olarak en yüksek miktarda ürün alan müþterinin adý, soyadý ve ödediði toplam para miktarýný bulunuz? 
select top 1 m.adi, m.soyadi, sum(u.fiyat*sd.adet) as 'Alýnan ürünlerin toplamý' from siparis_detay sd
inner join siparis s
on sd.siparis_id = s.siparis_id
inner join musteri m
on s.musteri_id = m.musteri_id
inner join urun u
on sd.urun_id = u.urun_id
inner join sube sb
on s.sube_id = sb.sube_id
where sb.sube_adi = 'Merkez' 
group by m.adi, m.soyadi
order by [Alýnan ürünlerin toplamý] desc




--10.soru:Müþteri listesinde bulunan ancak hiçbir maðazadan alýþveriþ yapmamýþ müþterilerin adý, soyadý adresi, telefonu ve mesleðini  müþteri soyadýna göre listeleyiniz?
select m.adi,m.soyadi,m.adres,m.telefon, ms.meslek from musteri m
left join siparis s
on s.musteri_id = m.musteri_id
inner join meslek ms
on m.meslek_id = ms.meslek_id 
where s.siparis_id is null
order by m.soyadi



--11.soru:  Gökçebey þubesinde Çamaþýr Makinesi kategorisinde hiç satýlmayan ürün adlarýný listeleyiniz? 
select u.urun_adi from urun u
inner join kategori k
on u.kategori_id = k.kategori_id
where k.kategori = 'Çamaþýr Makinesi' and u.urun_id not in
(select sd.urun_id from siparis_detay sd
inner join siparis s 
on sd.siparis_id = s.siparis_id
inner join sube sb
on sb.sube_id = s.sube_id
where sb.sube_adi = 'Gökçebey')


--12.soru:Ocak-Haziran arasýnda  (Ocak ve Haziran dahil) 6 ayda “Adrese teslim” þeklinde yapýlan satýþlarda en fazla satýlan ürün kegorisini ve sayýsýný bulunuz? 
select top 1 k.kategori ,sum(sd.adet) as 'Satýþ Miktarý' from siparis s
inner join siparis_detay sd
on sd.siparis_id = s.siparis_id
inner join gonderi g
on s.gonderi_id = g.gonderi_id
inner join urun u
on sd.urun_id = u.urun_id
inner join kategori k
on u.kategori_id = k.kategori_id
where (s.siparis_tarihi between '2024-01-01' and '2024-06-30') and g.gonderi_turu = 'Adrese Teslim'
group by k.kategori
order by [Satýþ Miktarý] desc



--13.soru: Çaycuma þubesinde Derin Dondurucu kategorisinde   “Kargo ile Gönderim” þeklinde  yapýlan satýþlarda sipariþlerin ortalama kaç gün içinde teslim edildiðini bulunuz? 
select cast(avg(cast(datediff(day, s.siparis_tarihi, s.teslim_tarihi) as decimal (10, 1))) as decimal(10, 1)) as 'Ortalama Teslim Süresi'  from siparis s
inner join siparis_detay sd
on sd.siparis_id = s.siparis_id
inner join urun u
on sd.urun_id = u.urun_id
inner join kategori k 
on u.kategori_id = k.kategori_id
inner join sube sb
on s.sube_id = sb.sube_id
inner join gonderi g
on s.gonderi_id = g.gonderi_id
where sb.sube_adi = 'Çaycuma' and k.kategori = 'Derin Dondurucu' and g.gonderi_turu = 'Kargo ile Gönderim' 


--14.soru: Mesleði “Memur” olan müþterilerin Aðustos ayý içeriside hiç satýn almadýklarý ürünlerin  kategorilerini bulunuz?    
select k.kategori from kategori k
left join
(select u.kategori_id from siparis s
inner join siparis_detay sd
on s.siparis_id = sd.siparis_id
inner join urun u
on u.urun_id = sd.urun_id
inner join musteri m
on s.musteri_id = m.musteri_id
inner join meslek ms
on m.meslek_id = ms.meslek_id
where ms.meslek = 'Memur' and month(s.siparis_tarihi) = 08
) as satin_alinan 
on k.kategori_id = satin_alinan.kategori_id
where satin_alinan.kategori_id is null



--15:soru : Temmuz ayý içerisinde her þubede satýlan “Klima” kategorisindeki ürün sayýsýný bulunuz. 
select sb.sube_adi, sum(sd.adet) as 'Satýlan Klima Sayýsý' from siparis s
inner join siparis_detay sd
on s.siparis_id = sd.siparis_id
inner join urun u
on u.urun_id = sd.urun_id
inner join kategori k
on u.kategori_id = k.kategori_id
inner join sube sb
on s.sube_id = sb.sube_id
where month(s.siparis_tarihi) = 07 and k.kategori = 'Klima'
group by sb.sube_adi
order by [Satýlan Klima Sayýsý] desc



--16.soru:En çok “Katý Meyve Sýkacaðý” satýlan þubenin hangisi olduðunu ve satýlan ürün sayýsýný  bulunuz? 
select top 1 sb.sube_adi, sum(sd.adet) as 'Satýlan Katý Meyve Sýkacaðý Sayýsý' from siparis s
inner join siparis_detay sd
on s.siparis_id = sd.siparis_id
inner join urun u
on u.urun_id = sd.urun_id
inner join kategori k
on u.kategori_id = k.kategori_id
inner join sube sb
on s.sube_id = sb.sube_id
where k.kategori = 'Katý Meyve Sýkacaðý'
group by sb.sube_adi
order by [Satýlan Katý Meyve Sýkacaðý Sayýsý] desc



--17.soru:Aðustos ayýnda Çaycuma þubesinde satýlan “Mikrodalga Fýrýn” kategorisindeki ürün sayýsý ile Temmuz 
--ayýnda Ereðli þubesinde satýlan “Kurutma Makinesi”  kategorisindeki ürün sayýsý toplamý kaçtýr?  
select 
(select sum(sd.adet) as mikrodalga from siparis s
inner join siparis_detay sd
on s.siparis_id = sd.siparis_id
inner join sube sb
on sb.sube_id = s.sube_id
inner join urun u
on sd.urun_id = u.urun_id
inner join kategori k
on u.kategori_id = k.kategori_id
where month(s.siparis_tarihi) = 08 and sb.sube_adi = 'Çaycuma' and k.kategori = 'Mikrodalga Fýrýn' ) +
(select sum(sd.adet) as kurutma from siparis s
inner join siparis_detay sd
on s.siparis_id = sd.siparis_id
inner join sube sb
on sb.sube_id = s.sube_id
inner join urun u
on sd.urun_id = u.urun_id
inner join kategori k
on u.kategori_id = k.kategori_id
where month(s.siparis_tarihi) = 07 and sb.sube_adi = 'Ereðli' and k.kategori = 'Kurutma Makinesi' ) as 'Satýlan ürün toplamý'



--18.soru:Hiçbir maðazada satýlmamýþ ürün adlarýný ve fiyatýný listeleyiniz. 
select u.urun_adi, u.fiyat  from urun u
left join siparis_detay sd
on sd.urun_id = u.urun_id
where sd.urun_id is null
order by u.urun_adi 



--19.soru:En çok satýlan üründen alan müþterilerin adýný, soyadýný ve mesleðini listeleyiniz.  (Not: En çok satýlan ürün adýna göre) 
select distinct m.adi,m.soyadi,ms.meslek  from musteri m
inner join siparis s
on s.musteri_id = m.musteri_id
inner join siparis_detay sd
on sd.siparis_id = s.siparis_id
inner join urun u
on sd.urun_id = u.urun_id
inner join meslek ms
on ms.meslek_id = m.meslek_id
where u.urun_id = 
(
select top 1 urun_id from siparis_detay 
group by urun_id
order by sum(adet) desc
)



--20.soru:Devrek ya da Gökçebey þubelerinden Mart, Nisan ve Mayýs aylarýnda “Kargo ile gönderim” þeklinde yapýlan satýþlarda gönderilen ürün kategori adýný ve ürün sayýsýný bulunuz? 
select k.kategori as kategori , sum(sd.adet) as 'Gönderilen Ürün Sayýsý' from siparis s
inner join siparis_detay sd
on s.siparis_id = sd.siparis_id
inner join sube sb
on sb.sube_id = s.sube_id
inner join gonderi g
on g.gonderi_id = s.gonderi_id
inner join urun u
on sd.urun_id = u.urun_id
inner join kategori k
on u.kategori_id = k.kategori_id
where sb.sube_adi in ('Devrek','Gökçebey') and month(s.siparis_tarihi) in (03,04,05) and g.gonderi_turu = 'Kargo ile gönderim'
group by k.kategori
