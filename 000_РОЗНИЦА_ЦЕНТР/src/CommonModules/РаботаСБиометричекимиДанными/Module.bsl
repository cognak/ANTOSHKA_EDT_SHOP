Функция ПолучитьБиометриюСотрудника(ФизЛицо)  Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	БиометрическиеДанные.ФизЛицо КАК ФизЛицо,
	               |	БиометрическиеДанные.Биометрия КАК Биометрия
	               |ИЗ
	               |	РегистрСведений.БиометрическиеДанные КАК БиометрическиеДанные
	               |ГДЕ
	               |	БиометрическиеДанные.ФизЛицо = &ФизЛицо"; 
	Запрос.УстановитьПараметр("ФизЛицо",ФизЛицо);
	Рез_ = Запрос.Выполнить().Выбрать();
	
	Если Рез_.Следующий() Тогда
		Возврат Рез_.Биометрия;
	Иначе
		Возврат "";
	КонецЕсли;
КонецФункции


Функция УстановитьБиометриюСотруднику(ФизЛицо,Биометрия) Экспорт
	РегБиометрия = РегистрыСведений.БиометрическиеДанные.СоздатьНаборЗаписей();
	РегБиометрия.Отбор.ФизЛицо.Установить(ФизЛицо);
	РегБиометрия.Прочитать();
	Если РегБиометрия.Количество()=0 Тогда
		Строка_ = РегБиометрия.Добавить();
	Иначе
		Строка_ = РегБиометрия[0];
	КонецЕсли;

	Строка_.Активность = Истина;
	Строка_.ФизЛицо = ФизЛицо;
	Строка_.Биометрия = Биометрия; 
	
	Попытка
		РегБиометрия.Записать(Истина);
		Результат = Истина;
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	Попытка
		ЗарегистрироватьИзмененияБиометрии(ФизЛицо, Перечисления.ВидыИзмененияБиометрическихДанных.Добавление);
	Исключение
		ЗаписьЖурналаРегистрации("Биометрия",УровеньЖурналаРегистрации.Ошибка,Метаданные.РегистрыСведений.ИсторияИзмененияБиометрическихДанных,,"Ошибка при записи истории изменении биометрии (Добавление) Сотрудник: "
				+ФизЛицо+", Ошибка: "+ОписаниеОшибки(),РежимТранзакцииЗаписиЖурналаРегистрации.Независимая);
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции    

Функция УдалитьБиометриюСотруднику(ФизЛицо) Экспорт
	//защита от дурака, чтобы не грохнули регистр
	Если Не ЗначениеЗаполнено(ФизЛицо) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	РегБиометрия = РегистрыСведений.БиометрическиеДанные.СоздатьНаборЗаписей();
	РегБиометрия.Отбор.ФизЛицо.Установить(ФизЛицо);
	РегБиометрия.Прочитать();
	РегБиометрия.Очистить();
	
	Попытка
		РегБиометрия.Записать(Истина);
		Результат = Истина;
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	Попытка
		ЗарегистрироватьИзмененияБиометрии(ФизЛицо, Перечисления.ВидыИзмененияБиометрическихДанных.Удаление);
	Исключение
		ЗаписьЖурналаРегистрации("Биометрия",УровеньЖурналаРегистрации.Ошибка,Метаданные.РегистрыСведений.ИсторияИзмененияБиометрическихДанных,,"Ошибка при записи истории изменении биометрии (Удаление) Сотрудник: "
				+ФизЛицо+", Ошибка: "+ОписаниеОшибки(),РежимТранзакцииЗаписиЖурналаРегистрации.Независимая);
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции    

Процедура ЗарегистрироватьИзмененияБиометрии(ФизЛицо, ВидИзменения)
	РегИзменения = РегистрыСведений.ИсторияИзмененияБиометрическихДанных.СоздатьМенеджерЗаписи();
	РегИзменения.Активность = Истина;
	РегИзменения.Период = ТекущаяДата();
	РегИзменения.ВидИзменения = ВидИзменения;
	РегИзменения.ФизЛицо = ФизЛицо;
	РегИзменения.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	РегИзменения.Записать(Истина);
КонецПроцедуры

Функция ИспользуетсяБиометрическийСканер(Магазин) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	УчетнаяПолитикаМагазиновСрезПоследних.Магазин КАК Магазин,
	               |	ЕСТЬNULL(УчетнаяПолитикаМагазиновСрезПоследних.ИспользоватьБиометрическийСканер, ЛОЖЬ) КАК ИспользуетсяБиометрическийСканер
	               |ИЗ
	               |	РегистрСведений.УчетнаяПолитикаМагазинов.СрезПоследних(, Магазин = &Магазин) КАК УчетнаяПолитикаМагазиновСрезПоследних";
	Запрос.УстановитьПараметр("Магазин",Магазин);
	Результат = Запрос.Выполнить().Выбрать();
	Если Результат.Следующий() Тогда
		Возврат Результат.ИспользуетсяБиометрическийСканер;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции


Функция ПолучитьСотрудниковСБиометрией()   Экспорт
	Магазин = ОбменДаннымиПовтИсп.ПолучитьДанныеУзла().Магазин;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	БиометрическиеДанные.ФизЛицо КАК ФизЛицо,
	               |	БиометрическиеДанные.Биометрия КАК Биометрия
	               |ИЗ
	               |	РегистрСведений.БиометрическиеДанные КАК БиометрическиеДанные
	               |ГДЕ
	               |	БиометрическиеДанные.ФизЛицо.Магазин = &Магазин";
	Запрос.УстановитьПараметр("Магазин",Магазин);
	ТаблицаСотрудников = Запрос.Выполнить().Выгрузить();
	
	//АдресТаблицы = ПоместитьВоВременноеХранилище(ТаблицаСотрудников);
	
	Возврат ТаблицаСотрудников;
КонецФункции