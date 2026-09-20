# Level table: en2ja (English speaker learning Japanese)

Base language: English. Learning language: Japanese. The ratio is the share of Japanese.

Base sentence (0%):
> This file validates the user input and saves it to the database. If an error occurs, it logs the error and aborts the process.

| Ratio | How to mix | Example |
|---|---|---|
| 0% | All English. | This file validates the user input and saves it to the database. If an error occurs, it logs the error and aborts the process. |
| 10% | English sentences. Swap one or two key nouns per paragraph into Japanese. | This file validates the user 入力 (nyūryoku — input) and saves it to the database. If an error occurs, it logs the error and aborts the process. |
| 20% | English sentences. Swap the key nouns into Japanese. | This file validates the user 入力 (nyūryoku — input) and saves it to the データベース (dētabēsu — database). If an エラー (erā — error) occurs, it logs the error and aborts the process. |
| 30% | English sentences. Swap key nouns and one predicate per sentence. | This file validates the user 入力 and saves it to the データベース. If an エラー occurs, it writes a ログ (rogu — log) and 中断します (chūdan shimasu — aborts the process). |
| 40% | English sentences with short Japanese phrases (noun + particle, verb phrases). | This file は validates the user 入力, then データベースに保存します (hozon shimasu — saves it). If an エラー occurs, ログに記録して aborts the process. |
| 50% | Alternate at the clause level: about half the clauses are Japanese. | This file validates the user input, それから database に保存します。If an error occurs, ログに記録して aborts the process. |
| 60% | Most clauses in Japanese; English keeps the connecting parts and some clauses. | This file では、user input を検証して、database に保存します。If an error occurs、ログに記録して processing を中断します。 |
| 70% | Mostly Japanese sentences. Keep one clause or the harder words in English. | このファイルでは、user input を検証してから、database に保存します。エラーが起きた場合は、ログに記録して処理を中断します。 |
| 80% | Japanese sentences. Put the English meaning of harder words in parentheses. | このファイル（this file）では、ユーザーの入力を検証（validate）してから、データベースに保存します。エラーが起きた場合は、ログに記録して処理を中断（abort）します。 |
| 90% | Japanese sentences. Add English only for rare or difficult words. | このファイルでは、ユーザーの入力を検証してから、データベースに保存します。エラーが起きた場合は、ログに記録して処理を中断（abort）します。 |
| 100% | All Japanese. | このファイルでは、ユーザーの入力を検証してから、データベースに保存しています。エラーが起きた場合は、ログに記録して処理を中断します。 |

## Reading support

Japanese script is the hardest part for a beginner, so give just enough help to keep reading possible:

- **Ratio 30% or below**: the first time a Japanese word appears in a reply, add romaji and the English meaning in parentheses — `入力 (nyūryoku — input)`. Later uses in the same reply need no gloss.
- **Ratio 40–60%**: add romaji only for words that are not everyday vocabulary, and only on first use.
- **Ratio 70% or above**: assume the user can read kana and common kanji. Add a gloss only for rare or technical words.
- Use normal Japanese punctuation (、。) inside Japanese text, and keep particles attached to the word they follow.
- Keep the politeness level steady: use です・ます form unless the user writes in plain form.
