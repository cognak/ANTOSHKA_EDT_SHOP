//	LNK 22.12.2017 10:32:26
Функция КлючиСортировки()	Экспорт

	Возврат "Код, Артикул, Производитель, ТорговаяМарка";

КонецФункции // КлючиСортировки()

//	LNK 22.12.2017 10:33:25
Функция СоответствиеКлючейСортировки(КлючиСортировки)	Экспорт

	СоответствиеКлючей = Новый Соответствие;

	Для каждого ИмяКлюча Из ОбщегоНазначенияКлиентСервер.lx_FillValueList(, КлючиСортировки,, ",") Цикл

		СоответствиеКлючей.Вставить(ИмяКлюча, Истина);

	КонецЦикла;

	Возврат СоответствиеКлючей;

КонецФункции // СоответствиеКлючейСортировки()

