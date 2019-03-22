// Реализация шагов BDD-фич/сценариев c помощью фреймворка https://github.com/artbear/1bdd

#Использовать gitrunner
#Использовать tempfiles
#Использовать asserts

Перем БДД;

Функция ПолучитьСписокШагов(КонтекстФреймворкаBDD) Экспорт
	
	БДД = КонтекстФреймворкаBDD;

	ВсеШаги = Новый Массив;
	ВсеШаги.Добавить("ЯСоздаюВременныйКаталогИЗапоминаюЕгоКак");
	ВсеШаги.Добавить("ЯСоздаюНовыйРепозиторийВКаталогеИЗапоминаюЕгоКак");	
	ВсеШаги.Добавить("ЯПереключаюсьВоВременныйКаталог");
	ВсеШаги.Добавить("ВКаталогеРепозиторияЕстьФайл");
	ВсеШаги.Добавить("ЯКопируюФайлВКаталогРепозитория");
	ВсеШаги.Добавить("ЯФиксируюИзмененияВРепозиторииСКомментарием");
	ВсеШаги.Добавить("ЯУстанавливаюКодировкуВыводаКоманды");
	ВсеШаги.Добавить("КодировкаФайлаИФайлаОдинаковая");
	ВсеШаги.Добавить("СодержимоеФайлаИФайлаРазное");
	
	Возврат ВсеШаги;
КонецФункции

// я создаю временный каталог и запоминаю его как "Алиас"
Процедура ЯСоздаюВременныйКаталогИЗапоминаюЕгоКак(Алиас) Экспорт
	
	НовыйВременныйКаталог = ВременныеФайлы.СоздатьКаталог();
	СоздатьКаталог(НовыйВременныйКаталог);

	БДД.СохранитьВКонтекст(Алиас, НовыйВременныйКаталог);

КонецПроцедуры

// я переключаюсь во временный каталог "АлиасКаталога"
Процедура ЯПереключаюсьВоВременныйКаталог(АлиасКаталога)Экспорт
	
	КаталогСкрипта = БДД.ПолучитьИзКонтекста("КаталогПроекта");
	Если НЕ ЗначениеЗаполнено(КаталогСкрипта) Тогда

		БДД.СохранитьВКонтекст("КаталогПроекта", ТекущийКаталог());

	КонецЕсли;

	КаталогРепозиториев = БДД.ПолучитьИзКонтекста(АлиасКаталога);
	УстановитьТекущийКаталог(КаталогРепозиториев);

КонецПроцедуры

// я создаю новый репозиторий "ИмяРепозитория" в каталоге "АлиасКаталога" и запоминаю его как "Алиас"
Процедура ЯСоздаюНовыйРепозиторийВКаталогеИЗапоминаюЕгоКак(ИмяРепозитория, АлиасКаталога, Алиас) Экспорт
	
	КаталогРепозиториев = БДД.ПолучитьИзКонтекста(АлиасКаталога);
	
	КаталогРепозитория = ОбъединитьПути(КаталогРепозиториев, ИмяРепозитория);
	СоздатьКаталог(КаталогРепозитория);

	РепозиторийGit = Новый ГитРепозиторий();
	РепозиторийGit.УстановитьРабочийКаталог(КаталогРепозитория);
	РепозиторийGit.Инициализировать();
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст("# Репозиторий " + Алиас);
	ИмяФайлаreadme = ОбъединитьПути(КаталогРепозитория, "readme.md");
	ТекстовыйДокумент.Записать(ИмяФайлаreadme);
	РепозиторийGit.ДобавитьФайлВИндекс(ИмяФайлаreadme);
	РепозиторийGit.Закоммитить("init", ИСТИНА);

	БДД.СохранитьВКонтекст(Алиас, КаталогРепозитория);

КонецПроцедуры

// В каталоге "ИмяКаталога" репозитория "ИмяРепозитория" есть файл "ИмяФайла"
Процедура ВКаталогеРепозиторияЕстьФайл(ИмяКаталога, ИмяРепозитория, ИмяФайла)Экспорт
	
	КаталогРепозитория = БДД.ПолучитьИзКонтекста(ИмяРепозитория);
	ПолноеИмяФайла = ОбъединитьПути(КаталогРепозитория, ИмяКаталога, ИмяФайла);
	Файл = Новый Файл(ПолноеИмяФайла);
	Ожидаем.Что(Файл.Существует(), Истина).ЭтоИстина();

КонецПроцедуры

// Я копирую файл "ИмяФайла" в каталог репозитория "АлиасРепозитория"
Процедура ЯКопируюФайлВКаталогРепозитория(ИмяФайла, АлиасРепозитория) Экспорт

	КаталогРепозитория = БДД.ПолучитьИзКонтекста(АлиасРепозитория);
	КаталогСкрипта = БДД.ПолучитьИзКонтекста("КаталогПроекта");
	ПутьКФайлу = ОбъединитьПути(КаталогСкрипта, ИмяФайла);
	Файл = Новый Файл(ПутьКФайлу);
	КопироватьФайл(ПутьКФайлу, ОбъединитьПути(КаталогРепозитория, Файл.Имя));

КонецПроцедуры

// я фиксирую изменения в репозитории "Репозиторий1" с комментарием "demo коммит"
Процедура ЯФиксируюИзмененияВРепозиторииСКомментарием(ИмяРепозитория, ТекстКомментария) Экспорт
	
	КаталогРепозитория = БДД.ПолучитьИзКонтекста(ИмяРепозитория);
	
	РепозиторийGit = Новый ГитРепозиторий();
	РепозиторийGit.УстановитьРабочийКаталог(КаталогРепозитория);
	ПараметрыКоманды = Новый Массив;
	ПараметрыКоманды.Добавить("add --all");
	РепозиторийGit.ВыполнитьКоманду(ПараметрыКоманды);

	РепозиторийGit.Закоммитить(ТекстКомментария, ИСТИНА);

КонецПроцедуры

// я устанавливаю кодировку вывода "Кодировка" команды "ИмяКоманды"
Процедура ЯУстанавливаюКодировкуВыводаКоманды(Кодировка, ИмяКоманды) Экспорт
	КлючКонтекста = КлючКоманды(ИмяКоманды);
	Команда = БДД.ПолучитьИзКонтекста(КлючКонтекста);
	Команда.УстановитьКодировкуВывода(Кодировка);
КонецПроцедуры

Функция КлючКоманды(Знач ИмяКоманды)
	Возврат "Команда-" + ИмяКоманды;
КонецФункции

КонецПроцедуры

// Содержимое файла "ИсходныйФайл" и файла "КонечныйФайл" разное 
Процедура СодержимоеФайлаИФайлаРазное(ИсходныйФайл, КонечныйФайл) Экспорт
	
	ИсходныйФайл = ОбъединитьПути(БДД.ПолучитьИзКонтекста("КаталогПроекта"), ИсходныйФайл);
	КонечныйФайл = ОбъединитьПути(БДД.ПолучитьИзКонтекста("РабочийКаталог"), КонечныйФайл);
	
	СодержимоеКонечногоФайла = ПрочитатьТекстФайла(КонечныйФайл);
	СодержимоеИсходногоФайла = ПрочитатьТекстФайла(ИсходныйФайл);
	
	Ожидаем.Что(СодержимоеИсходногоФайла).Не_().Равно(СодержимоеКонечногоФайла);

КонецПроцедуры

// Кодировка файла "ИсходныйФайл" и файла "КонечныйФайл" одинаковая 
Процедура КодировкаФайлаИФайлаОдинаковая(ИсходныйФайл, КонечныйФайл) Экспорт
	
	ИсходныйФайл = ОбъединитьПути(БДД.ПолучитьИзКонтекста("КаталогПроекта"), ИсходныйФайл);
	КонечныйФайл = ОбъединитьПути(БДД.ПолучитьИзКонтекста("РабочийКаталог"), КонечныйФайл);
	
	КодировкаИсходногоФайла = ОпределитьКодировку(ИсходныйФайл);
	КодировкаКонечногоФайла = ОпределитьКодировку(КонечныйФайл);
	
	Ожидаем.Что(КодировкаИсходногоФайла).Равно(КодировкаКонечногоФайла);


Функция ПрочитатьТекстФайла(ПутьКФайлу) Экспорт
	
	Кодировка	= ОпределитьКодировку(ПутьКФайлу);
	Текст		= Новый ЧтениеТекста();
	Текст.Открыть(ПутьКФайлу, Кодировка);
	
	СодержимоеФайла = Текст.Прочитать();
	
	Текст.Закрыть();
	
	Возврат СодержимоеФайла;
	
КонецФункции // ПрочитатьТекстФайла

Функция ОпределитьКодировку(ПутьКФайлу)
	
	МаркерUTFBOM	= СтрРазделить("239 187 191", " ");
	ЧтениеДанных	= Новый ЧтениеДанных(ПутьКФайлу);
	Буфер			= Новый БуферДвоичныхДанных(МаркерUTFBOM.Количество());
	
	ЧтениеДанных.ПрочитатьВБуферДвоичныхДанных(Буфер, , МаркерUTFBOM.Количество());
	cч		= 0;
	ЕстьBOM	= Истина;
	
	Для Каждого Байт ИЗ Буфер Цикл
		
		Если МаркерUTFBOM[сч] <> Строка(Байт) Тогда
			
			ЕстьBOM = Ложь;
			Прервать;
			
		КонецЕсли;
		
		сч = сч + 1;
		
	КонецЦикла;
	
	ЧтениеДанных.Закрыть();
	
	Возврат ?(ЕстьBOM, КодировкаТекста.UTF8, КодировкаТекста.UTF8NoBOM);
	
КонецФункции //ОпределитьКодировку

