# Участие в проекта / Contributing

## Български

Благодарим за интереса към Astro Site Builder! Предложенията за подобрения и докладите за грешки са добре дошли.

### Докладване на проблем

Включи версията на генератора, операционната система, версията на Node.js и точните стъпки за възпроизвеждане. Премахни лични данни, токени и други тайни от логовете, преди да ги споделиш.

### Промени в кода

1. Направи промяната в отделен branch.
2. Изпълни `bash -n astro-site-builder.sh`.
3. Изпълни `bash tests/test-builder.sh`.
4. Ако променяш генерирания Astro проект, създай тестов сайт в празна директория и изпълни `npm run check` и `npm run build`.
5. Актуализирай `CHANGELOG.md` и `CHANGELOG.en.md`, когато промяната засяга потребителите.

Поддържай документацията на български и английски, когато добавяш нови инструкции или променяш съществуващи.

## English

Thanks for your interest in Astro Site Builder! Bug reports and improvement proposals are welcome.

### Reporting an issue

Include the builder version, operating system, Node.js version and exact reproduction steps. Remove personal data, tokens and other secrets from logs before sharing them.

### Code changes

1. Make your change on a separate branch.
2. Run `bash -n astro-site-builder.sh`.
3. Run `bash tests/test-builder.sh`.
4. If you change the generated Astro project, create a test site in an empty directory and run `npm run check` and `npm run build`.
5. Update `CHANGELOG.md` and `CHANGELOG.en.md` when the change affects users.

Keep documentation in both Bulgarian and English when adding or changing instructions.
