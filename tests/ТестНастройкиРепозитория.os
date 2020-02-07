#Использовать asserts
#Использовать logos
#Использовать tempfiles
#Использовать "../src"

Перем юТест;
Перем Лог;
Перем МенеджерВременныхФайлов;

// Основная точка входа
Функция ПолучитьСписокТестов(ЮнитТестирование) Экспорт
	
	ПередЗапускомТестов();

	юТест = ЮнитТестирование;
	
	ВсеТесты = Новый Массив;
	
	ВсеТесты.Добавить("Тест_ИспользованиеГлобальныхНастроек");
	ВсеТесты.Добавить("Тест_ИспользованиеЛокальныхНастроек");
	ВсеТесты.Добавить("Тест_ОтключенныеНастройки");
	ВсеТесты.Добавить("Тест_ОтключенныеНастройкиИПереопределенныеГлобальныеСценарии");

	ВсеТесты.Добавить("Тест_НастройкиПроектов");
	
	Возврат ВсеТесты;
	
КонецФункции

Процедура ПередЗапускомТестов()

	МенеджерПриложения.Инициализировать(ПараметрыПриложения);

	ВремТестер = Новый Тестер;
	Лог = Логирование.ПолучитьЛог(ВремТестер.ИмяЛога());

КонецПроцедуры

Процедура ПередЗапускомТеста() Экспорт
	
	ВключитьПоказОтладки();
	
	МенеджерВременныхФайлов = Новый МенеджерВременныхФайлов;
	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	
	МенеджерВременныхФайлов.Удалить();
	МенеджерВременныхФайлов = Неопределено;
	
КонецПроцедуры

Процедура Тест_ИспользованиеГлобальныхНастроек() Экспорт
	
	НастройкиПрекоммит = ЗагрузитьНастройкиИзФикстуры("v8configБезНастроекПрекоммит.json");
	
	Ожидаем.Что(НастройкиПрекоммит, "Не удалось загрузить настройки").Заполнено();
	
КонецПроцедуры

Процедура Тест_ИспользованиеЛокальныхНастроек() Экспорт

	НастройкиПрекоммит = ЗагрузитьНастройкиИзФикстуры("v8config.json");
	
	Ожидаем.Что(НастройкиПрекоммит, "Не удалось загрузить настройки").Заполнено();
	
	ОжидаемыеСценарии = Новый Массив();
	ОжидаемыеСценарии.Добавить("УдалениеДублейМетаданных.os");
	ОжидаемыеСценарии.Добавить("УдалениеЛишнихКонцевыхПробелов.os");
	ОжидаемыеСценарии.Добавить("УдалениеЛишнихПустыхСтрок.os");
	
	ПроверитьОжидаемыеСценарии(НастройкиПрекоммит["ГлобальныеСценарии"], ОжидаемыеСценарии);
		
КонецПроцедуры

Процедура Тест_ОтключенныеНастройки() Экспорт

	НастройкиПрекоммит = ЗагрузитьНастройкиИзФикстуры("v8configОтключенныеСценарии.json");
	
	Ожидаем.Что(НастройкиПрекоммит, "Не удалось загрузить настройки").Заполнено();
	
	ОжидаемыеСценарии = Новый Массив();
    ОжидаемыеСценарии.Добавить("ДобавлениеПробеловПередКлючевымиСловами.os");
    ОжидаемыеСценарии.Добавить("ЗапретИспользованияПерейти.os");
    ОжидаемыеСценарии.Добавить("ИсправлениеНеКаноническогоНаписания.os");
    ОжидаемыеСценарии.Добавить("КорректировкаXMLФорм.os");
    ОжидаемыеСценарии.Добавить("ОтключениеПолнотекстовогоПоиска.os");
    ОжидаемыеСценарии.Добавить("ПроверкаДублейПроцедурИФункций.os");
    ОжидаемыеСценарии.Добавить("ПроверкаКорректностиОбластей.os");
    ОжидаемыеСценарии.Добавить("РазборОбычныхФормНаИсходники.os");
    ОжидаемыеСценарии.Добавить("РазборОтчетовОбработокРасширений.os");
    ОжидаемыеСценарии.Добавить("СинхронизацияОбъектовМетаданныхИФайлов.os");
	ОжидаемыеСценарии.Добавить("СортировкаДереваМетаданных.os");
	
	ИменаЗагружаемыхСценариев = МенеджерНастроек.ИменаЗагружаемыхСценариев();

	ПроверитьОжидаемыеСценарии(ИменаЗагружаемыхСценариев, ОжидаемыеСценарии);

	ИменаЗагружаемыхСценариев = МенеджерНастроек.ИменаЗагружаемыхСценариев("Несуществующий проект");

	ПроверитьОжидаемыеСценарии(ИменаЗагружаемыхСценариев, ОжидаемыеСценарии);

КонецПроцедуры

Процедура Тест_ОтключенныеНастройкиИПереопределенныеГлобальныеСценарии() Экспорт

	НастройкиПрекоммит = ЗагрузитьНастройкиИзФикстуры("v8configОтключенныеСценарииПереопреденыГлобальные.json");
	
	Ожидаем.Что(НастройкиПрекоммит, "Не удалось загрузить настройки").Заполнено();
	
	ОжидаемыеСценарии = Новый Массив();
    ОжидаемыеСценарии.Добавить("РазборОбычныхФормНаИсходники.os");
    ОжидаемыеСценарии.Добавить("РазборОтчетовОбработокРасширений.os");
    ОжидаемыеСценарии.Добавить("СинхронизацияОбъектовМетаданныхИФайлов.os");
	ОжидаемыеСценарии.Добавить("СортировкаДереваМетаданных.os");
	
	ИменаЗагружаемыхСценариев = МенеджерНастроек.ИменаЗагружаемыхСценариев();

	ПроверитьОжидаемыеСценарии(ИменаЗагружаемыхСценариев, ОжидаемыеСценарии);

	ИменаЗагружаемыхСценариев = МенеджерНастроек.ИменаЗагружаемыхСценариев("Несуществующий проект");

	ПроверитьОжидаемыеСценарии(ИменаЗагружаемыхСценариев, ОжидаемыеСценарии);

КонецПроцедуры

Процедура Тест_НастройкиПроектов() Экспорт
	
	ВсеСценарии = МенеджерНастроек.ПолучитьИменаСценариевКаталога(МенеджерПриложения.КаталогСценариев());

	НастройкиПрекоммит = ЗагрузитьНастройкиИзФикстуры("v8configПроекты.json");
	
	Ожидаем.Что(МенеджерНастроек.ПроектыКонфигурации(), "Не найден проект настроек").Содержит("configuration");
	Ожидаем.Что(МенеджерНастроек.ПроектыКонфигурации(), "Не найден проект настроек").Содержит("ext/extension1");
		
	ПроверитьЗначение("ИспользоватьСценарииРепозитория", "configuration", Ложь);
	ПроверитьЗначение("ИспользоватьСценарииРепозитория", "ext/extension1", Истина);
	ПроверитьЗначение("ИспользоватьСценарииРепозитория", "ext/extension2", Истина, "Несуществующий проект");

	ПроверитьЗначение("КаталогЛокальныхСценариев", "ext/extension1", "localscenario");
	ПроверитьЗначение("КаталогЛокальныхСценариев", "ext/extension2", "", "Несуществующий проект");
	
	Сценарии = МенеджерНастроек.ИменаЗагружаемыхСценариев("configuration");
	Ожидаем.Что(Сценарии.Количество(), "Сценарии проекта 'configuration'").Равно(0);

	Сценарии = МенеджерНастроек.ИменаЗагружаемыхСценариев("ext/extension1");
	Ожидаем.Что(Сценарии.Количество(), "Сценарии проекта 'ext/extension1'").Равно(ВсеСценарии.Количество());

	Сценарии = МенеджерНастроек.ИменаЗагружаемыхСценариев("ext/extension2");
	Ожидаем.Что(Сценарии.Количество(), "Сценарии проекта 'ext/extension2' несуществующий проект").Равно(ВсеСценарии.Количество() - 1);

	НастройкаConfiguration = МенеджерНастроек.НастройкиПроекта("configuration");
	Ожидаем.Что(НастройкаConfiguration,
		"Не корректные настройки проекта")
		.Не_().Равно(НастройкиПрекоммит);

	НастройкаExtension1 = МенеджерНастроек.НастройкиПроекта("ext/extension1");
	Ожидаем.Что(НастройкаExtension1,
			"Не корректные настройки проекта")
			.Не_().Равно(НастройкиПрекоммит);
	Ожидаем.Что(МенеджерНастроек.НастройкиПроекта("configuration2"), 
		"Не корректные настройки проекта. Для отсутствующего проекта должны возвращаться общие настройки")
		.Равно(НастройкиПрекоммит);
		
	ВариантыПроверки = Новый ТаблицаЗначений();
	ВариантыПроверки.Колонки.Добавить("ИмяФайла");
	ВариантыПроверки.Колонки.Добавить("Настройка");
	ДобавитьВариантНастройки(ВариантыПроверки, "configuration\module.bsl", 	НастройкаConfiguration);
	ДобавитьВариантНастройки(ВариантыПроверки, "ext\extension1\module.bsl", НастройкаExtension1);
	ДобавитьВариантНастройки(ВариантыПроверки, "\confiGuration\module.bsl", НастройкаConfiguration);
	ДобавитьВариантНастройки(ВариантыПроверки, "test\module.bsl", 			НастройкиПрекоммит);
	ДобавитьВариантНастройки(ВариантыПроверки, "module.bsl",	 			НастройкиПрекоммит);
	ДобавитьВариантНастройки(ВариантыПроверки, "",				 			НастройкиПрекоммит);
	
	Для каждого Вариант Из ВариантыПроверки Цикл
		
		Ожидаем.Что(МенеджерНастроек.НастройкаДляФайла(Вариант.ИмяФайла),
			СтрШаблон("Не верно определена настройка для файла '%1'", Вариант.ИмяФайла))
			.Равно(Вариант.Настройка);
		
	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьВариантНастройки(Варианты, Значение1, Значение2)
	
	Строка = Варианты.Добавить();
	
	Строка[0] = Значение1;
	Строка[1] = Значение2;

КонецПроцедуры

Процедура ПроверитьЗначение(Ключ, Проект, ОжидаемоеЗначение, Дополнение = "")

	Ожидаем.Что(МенеджерНастроек.ЗначениеНастройки(Ключ, Проект), 
		СтрШаблон("Не верное значение настройки '%1.%2' %3", Проект, Ключ, Дополнение))
		.Равно(ОжидаемоеЗначение);
		
КонецПроцедуры

#Область Служебные

Процедура ПроверитьОжидаемыеСценарии(ГлобальныеСценарии, ОжидаемыеСценарии)

	Ожидаем.Что(ГлобальныеСценарии, "Нет глобальных сценариев").Заполнено();
	
	Ожидаем.Что(ГлобальныеСценарии.Количество(), "Не корректный список сценариев").Равно(ОжидаемыеСценарии.Количество());
	
	Для каждого ИмяСценария Из ОжидаемыеСценарии Цикл
	
		Ожидаем.Что(ГлобальныеСценарии, "Не содержит нужные сценарии").Содержит(ИмяСценария)
		
	КонецЦикла;
		
КонецПроцедуры

Процедура ВключитьПоказОтладки()
	Лог.УстановитьУровень(УровниЛога.Отладка);
КонецПроцедуры

Процедура ВыключитьПоказОтладки()
	Лог.УстановитьУровень(УровниЛога.Информация);
КонецПроцедуры

Функция ЗагрузитьНастройкиИзФикстуры(ИмяФикстуры)

	КаталогРепозитория = СоздатьТестовыйКаталог(ИмяФикстуры);
	
	Настройки = МенеджерНастроек.НастройкиРепозитория(КаталогРепозитория);
	
	Возврат Настройки.НастройкиПриложения(МенеджерНастроек.КлючНастройкиPrecommit());

КонецФункции

Функция СоздатьТестовыйКаталог(ИмяФикстуры)
	
	Каталог = МенеджерВременныхФайлов.СоздатьКаталог();
	
	КаталогФикстур = ОбъединитьПути(ТекущийСценарий().Каталог, "fixtures", "Настройки");
	Фикстура = ОбъединитьПути(КаталогФикстур, ИмяФикстуры);
	
	КопироватьФайл(Фикстура, ОбъединитьПути(Каталог, "v8config.json"));
	
	Возврат Каталог;

КонецФункции

#КонецОбласти