#Область МеханизмРегистрацииОбъектов

//	LNK 13.03.2018 14:53:10
Процедура ПоУстройствамАнтошкаЗарегистрироватьИзменениеПередЗаписью(Источник, Отказ) Экспорт

	Если НЕ ОбменДаннымиADCTСерверПовтИсп.ВыполнятьРегистрацию() Тогда

		Возврат;

	КонецЕсли;

	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ПоУстройствамАнтошка", Источник, Отказ);

КонецПроцедуры

//	LNK 26.04.2018 12:15:04
Процедура ПоУстройствамАнтошкаЗарегистрироватьИзменениеДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт

	Если НЕ ОбменДаннымиADCTСерверПовтИсп.ВыполнятьРегистрацию() Тогда

		Возврат;

	КонецЕсли;


КонецПроцедуры

//	LNK 13.03.2018 14:57:02
Процедура ПоУстройствамАнтошкаЗарегистрироватьИзменениеНабораЗаписей(Источник, Отказ, Замещение) Экспорт

	Если НЕ ОбменДаннымиADCTСерверПовтИсп.ВыполнятьРегистрацию() Тогда

		Возврат;

	КонецЕсли;

	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ПоУстройствамАнтошка", Источник, Отказ, Замещение);

КонецПроцедуры

//	LNK 13.03.2018 15:00:29
Процедура ПоУстройствамАнтошкаЗарегистрироватьУдаление(Источник, Отказ) Экспорт

	Если НЕ ОбменДаннымиADCTСерверПовтИсп.ВыполнятьРегистрацию() Тогда

		Возврат;

	КонецЕсли;

	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ПоУстройствамАнтошка", Источник, Отказ);

КонецПроцедуры

#КонецОбласти







