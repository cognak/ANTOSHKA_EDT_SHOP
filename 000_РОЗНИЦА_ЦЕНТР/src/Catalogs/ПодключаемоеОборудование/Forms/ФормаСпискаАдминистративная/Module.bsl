&НаКлиенте	//	LNK 03.12.2023 07:40:40
Процедура НастроитьВыполнить()

	ОчиститьСообщения();
	СообщениеОбОшибке = "";
	НастройкиИзменены = Ложь;

	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда

		Возврат;

	КонецЕсли;
	
//	LNK 22.07.2019 11:59:31
	Если НЕ МенеджерОборудованияКлиент.ДрайверУстановлен(Элементы.Список.ТекущиеДанные.Ссылка) Тогда

		Результат = Вопрос(НСтр("ru = 'Установить драйвер?'"), РежимДиалогаВопрос.ДаНет);

		Если Результат = КодВозвратаДиалога.Да Тогда

			МенеджерОборудованияКлиент.УстановитьДрайвер(Элементы.Список.ТекущиеДанные.Ссылка);

		КонецЕсли;

	КонецЕсли;
	
	Результат = МенеджерОборудованияКлиент.ВыполнитьНастройкуОборудования(
				Элементы.Список.ТекущиеДанные.Ссылка,
				НастройкиИзменены,
				СообщениеОбОшибке
	);

	Если Результат И НастройкиИзменены Тогда

	//	Настройки были изменены
		ОбновитьПовторноИспользуемыеЗначения();

	ИначеЕсли НЕ Результат Тогда

		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке);

	КонецЕсли;

КонецПроцедуры
