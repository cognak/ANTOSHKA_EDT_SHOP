////////////////////////////////////////////////////////////////////////////////
// Подсистема "Завершение работы пользователей".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Получить сохраненные параметры администрирования кластера серверов.
// 
// Возвращаемое значение:
//   Структура – с полями, возвращаемыми функцией НовыеПараметрыАдминистрированияИБ.
//
Функция ПолучитьПараметрыАдминистрированияИБ() Экспорт

	Возврат СоединенияИБ.ПолучитьПараметрыАдминистрированияИБ();
	
КонецФункции

// Возвращает структуру с параметрами для принудительного отключения сеансов.
//
Функция ПараметрыОтключенияСеансов() Экспорт
	
	ТипПлатформыСервера = ОбщегоНазначенияПовтИсп.ТипПлатформыСервера();
	
	Возврат Новый Структура("НомерСеансаИнформационнойБазы,WindowsПлатформаНаСервере",
		НомерСеансаИнформационнойБазы(),
		ТипПлатформыСервера = ТипПлатформы.Windows_x86
			Или ТипПлатформыСервера = ТипПлатформы.Windows_x86_64);
	
КонецФункции
