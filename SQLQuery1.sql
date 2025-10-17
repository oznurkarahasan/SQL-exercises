--urun.kategori id foreign key her �r�n�n sadece bir kategorisi olabilir

--1.soru:Devrek ma�azas�ndan �r�n kategorisi Buzdolab� olan �r�nlerden alan m��terilerin ad�, soyad�, telefon numaras�, adresi, �r�n ad� 
--ve sipari� tarihini, sipari� tarihi yeniden eskiye do�ru s�ralanm�� �ekilde listeleyiniz?
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
where sb.sube_adi = 'Devrek' and kategori = 'Buzdolab�' order by s.siparis_tarihi desc




--2.soru:May�s ay� i�erisinde Kozlu ma�azas�ndan �Set �st� Ocak� kategorisinde �r�n alan m��terilerin ad�, soyad�, �r�n ad�, �r�n fiyat� bilgilerini listeleyiniz? 
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
where month(s.siparis_tarihi) = 05 and sb.sube_adi = 'Kozlu' and k.kategori = 'Set �st� Ocak'



--3.soru:Ere�li, Devrek ya da �aycuma �ubelerinden g�nderi t�r� �Ma�azadan Teslim� �eklinde �r�n alan m��teri ad�, soyad�, adresi, 
--mesle�i, �r�n ad�, �r�n fiyat� ve Sipari�i alan personelin ad�, soyad� , �ube ad� ve gonderi t�r�  bilgilerini listeleyiniz? 
select m.adi, m.soyadi, m.adres, ms.meslek, u.urun_adi, u.fiyat, p.adi as 'Personel Ad�', p.soyadi as 'Personel Soyad�', sb.sube_adi, g.gonderi_turu  from siparis_detay sd
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
where (sb.sube_adi = 'Ere�li' or sb.sube_adi = 'Devrek' or sb.sube_adi = '�aycuma' ) and g.gonderi_turu = 'Ma�azadan Teslim'




--4.soru: Kilimli �ubesinde sat�lan toplam Buzdolab�, �t�, Mikser ya da Su Is�t�c� kategorisindeki �r�n say�s�n� bulunuz? 
select sum(sd.adet) as 'Sat�lan toplam �r�n say�s�' from siparis_detay sd
inner join siparis s
on sd.siparis_id = s.siparis_id
inner join urun u
on sd.urun_id = u.urun_id
inner join kategori k
on u.kategori_id = k.kategori_id
inner join sube sb
on s.sube_id = sb.sube_id
where sb.sube_adi = 'Kilimli' and (k.kategori = 'Buzdolab�' or k.kategori = '�t�' or k.kategori = 'Mikser' or k.kategori = 'Su Is�t�c�')


--5.soru:�aycuma ma�azas�nda Mart- Haziran aras� (Mart, Haziran dahil) 4 ayda adet olarak en �ok sat�lan �r�n�n ad�n� ve Sat�� Adedini bulunuz. 
select top 1 u.urun_adi, sum(sd.adet) as 'Sat�� Adedi' from siparis_detay sd
inner join siparis s
on sd.siparis_id = s.siparis_id
inner join urun u
on sd.urun_id = u.urun_id
inner join kategori k
on u.kategori_id = k.kategori_id
inner join sube sb
on s.sube_id = sb.sube_id
where sb.sube_adi = '�aycuma' and month(s.siparis_tarihi) between 3 and 6
group by u.urun_adi
order by [Sat�� Adedi] desc




--6.soru:Kozlu ma�azas�nda parasal miktar olarak en fazla sat�� yapan personelin ad�n�, soyad�n�, ve sat�� miktar�n� listeleyiniz? 
select top 1 p.adi, p.soyadi, sum(u.fiyat*sd.adet) as 'Sat�� Miktar�' from siparis_detay sd
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
order by [Sat�� Miktar�] desc



--7.soru:Merkez, Kozlu, Kilimli ve Devrek ma�azalar�nda sat�lan Buzdolab� kategorisindeki �r�n say�s�n� bulunuz? 
select sum(sd.adet) as 'Sat�lan toplam �r�n say�s�'  from siparis_detay sd
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
where sb.sube_adi in ('Merkez', 'Kozlu', 'Kilimli' , 'Devrek') and k.kategori = 'Buzdolab�'



--8.soru:�SAL�H UZUN� isimli m��terinin ald��� �r�nlerin;  �r�n ad�, kategori, �r�n adedi, �r�n fiyatlar�, tutarlar�n� ve sipari� tarihlerini sipari� tarihi yeniden eskiye do�ru  listeleyiniz? 
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
where m.adi = 'SAL�H' and m.soyadi='UZUN' 
order by s.siparis_tarihi desc



--9.soru:Merkez �ubesinden parasal tutar olarak en y�ksek miktarda �r�n alan m��terinin ad�, soyad� ve �dedi�i toplam para miktar�n� bulunuz? 
select top 1 m.adi, m.soyadi, sum(u.fiyat*sd.adet) as 'Al�nan �r�nlerin toplam�' from siparis_detay sd
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
order by [Al�nan �r�nlerin toplam�] desc




--10.soru:M��teri listesinde bulunan ancak hi�bir ma�azadan al��veri� yapmam�� m��terilerin ad�, soyad� adresi, telefonu ve mesle�ini  m��teri soyad�na g�re listeleyiniz?
select m.adi,m.soyadi,m.adres,m.telefon, ms.meslek from musteri m
left join siparis s
on s.musteri_id = m.musteri_id
inner join meslek ms
on m.meslek_id = ms.meslek_id 
where s.siparis_id is null
order by m.soyadi



--11.soru:  G�k�ebey �ubesinde �ama��r Makinesi kategorisinde hi� sat�lmayan �r�n adlar�n� listeleyiniz? 
select u.urun_adi from urun u
inner join kategori k
on u.kategori_id = k.kategori_id
where k.kategori = '�ama��r Makinesi' and u.urun_id not in
(select sd.urun_id from siparis_detay sd
inner join siparis s 
on sd.siparis_id = s.siparis_id
inner join sube sb
on sb.sube_id = s.sube_id
where sb.sube_adi = 'G�k�ebey')


--12.soru:Ocak-Haziran aras�nda  (Ocak ve Haziran dahil) 6 ayda �Adrese teslim� �eklinde yap�lan sat��larda en fazla sat�lan �r�n kegorisini ve say�s�n� bulunuz? 
select top 1 k.kategori ,sum(sd.adet) as 'Sat�� Miktar�' from siparis s
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
order by [Sat�� Miktar�] desc



--13.soru: �aycuma �ubesinde Derin Dondurucu kategorisinde   �Kargo ile G�nderim� �eklinde  yap�lan sat��larda sipari�lerin ortalama ka� g�n i�inde teslim edildi�ini bulunuz? 
select cast(avg(cast(datediff(day, s.siparis_tarihi, s.teslim_tarihi) as decimal (10, 1))) as decimal(10, 1)) as 'Ortalama Teslim S�resi'  from siparis s
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
where sb.sube_adi = '�aycuma' and k.kategori = 'Derin Dondurucu' and g.gonderi_turu = 'Kargo ile G�nderim' 


--14.soru: Mesle�i �Memur� olan m��terilerin A�ustos ay� i�eriside hi� sat�n almad�klar� �r�nlerin  kategorilerini bulunuz?    
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



--15:soru : Temmuz ay� i�erisinde her �ubede sat�lan �Klima� kategorisindeki �r�n say�s�n� bulunuz. 
select sb.sube_adi, sum(sd.adet) as 'Sat�lan Klima Say�s�' from siparis s
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
order by [Sat�lan Klima Say�s�] desc



--16.soru:En �ok �Kat� Meyve S�kaca��� sat�lan �ubenin hangisi oldu�unu ve sat�lan �r�n say�s�n�  bulunuz? 
select top 1 sb.sube_adi, sum(sd.adet) as 'Sat�lan Kat� Meyve S�kaca�� Say�s�' from siparis s
inner join siparis_detay sd
on s.siparis_id = sd.siparis_id
inner join urun u
on u.urun_id = sd.urun_id
inner join kategori k
on u.kategori_id = k.kategori_id
inner join sube sb
on s.sube_id = sb.sube_id
where k.kategori = 'Kat� Meyve S�kaca��'
group by sb.sube_adi
order by [Sat�lan Kat� Meyve S�kaca�� Say�s�] desc



--17.soru:A�ustos ay�nda �aycuma �ubesinde sat�lan �Mikrodalga F�r�n� kategorisindeki �r�n say�s� ile Temmuz 
--ay�nda Ere�li �ubesinde sat�lan �Kurutma Makinesi�  kategorisindeki �r�n say�s� toplam� ka�t�r?  
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
where month(s.siparis_tarihi) = 08 and sb.sube_adi = '�aycuma' and k.kategori = 'Mikrodalga F�r�n' ) +
(select sum(sd.adet) as kurutma from siparis s
inner join siparis_detay sd
on s.siparis_id = sd.siparis_id
inner join sube sb
on sb.sube_id = s.sube_id
inner join urun u
on sd.urun_id = u.urun_id
inner join kategori k
on u.kategori_id = k.kategori_id
where month(s.siparis_tarihi) = 07 and sb.sube_adi = 'Ere�li' and k.kategori = 'Kurutma Makinesi' ) as 'Sat�lan �r�n toplam�'



--18.soru:Hi�bir ma�azada sat�lmam�� �r�n adlar�n� ve fiyat�n� listeleyiniz. 
select u.urun_adi, u.fiyat  from urun u
left join siparis_detay sd
on sd.urun_id = u.urun_id
where sd.urun_id is null
order by u.urun_adi 



--19.soru:En �ok sat�lan �r�nden alan m��terilerin ad�n�, soyad�n� ve mesle�ini listeleyiniz.  (Not: En �ok sat�lan �r�n ad�na g�re) 
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



--20.soru:Devrek ya da G�k�ebey �ubelerinden Mart, Nisan ve May�s aylar�nda �Kargo ile g�nderim� �eklinde yap�lan sat��larda g�nderilen �r�n kategori ad�n� ve �r�n say�s�n� bulunuz? 
select k.kategori as kategori , sum(sd.adet) as 'G�nderilen �r�n Say�s�' from siparis s
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
where sb.sube_adi in ('Devrek','G�k�ebey') and month(s.siparis_tarihi) in (03,04,05) and g.gonderi_turu = 'Kargo ile g�nderim'
group by k.kategori
