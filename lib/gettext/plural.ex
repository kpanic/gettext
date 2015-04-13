defmodule Gettext.Plural.Helpers do
  @moduledoc false

  @doc """
  Tells if the last digit of `n` is one of `digits`.

  Can be used in function guards.
  """
  defmacro ends_in(n, digits) do
    digits = List.wrap(digits)
    quote do
      rem(unquote(n), 10) in unquote(digits)
    end
  end
end

defmodule Gettext.Plural do
  @moduledoc """
  Provides plural form formulas for most languages.

  This module implements the `Gettext.Plural` behaviour. It calculates to which
  plural form a given number of elements belongs to in a given language. Most
  languages on Earth should be covered here.

  The plural form formulas have been taken from [this
  page](http://localization-guide.readthedocs.org/en/latest/l10n/pluralforms.html#f2)
  as well as from [Mozilla's "Localization ang plurals"
  guide](https://developer.mozilla.org/en-US/docs/Mozilla/Localization/Localization_and_Plurals).

  ## Examples

  An example of the plural form of a given number of element in Polish:

      iex> Plural.plural("pl", 1)
      0
      iex> Plural.plural("pl", 2)
      1
      iex> Plural.plural("pl", 5)
      2
      iex> Plural.plural("pl", 112)
      2

  As expected, `nplurals/1` returns the possible number of plural forms:

      iex> Plural.nplurals("pl")
      3

  """

  @behaviour Gettext.Pluralizer

  import Gettext.Plural.Helpers

  @one_form Enum.uniq [
    "ay",  # Aymará
    "bo",  # Tibetan
    "cgg", # Chiga
    "dz",  # Dzongkha
    "fa",  # Persian
    "id",  # Indonesian
    "ja",  # Japanese
    "jbo", # Lojban
    "ka",  # Georgian
    "kk",  # Kazakh
    "km",  # Khmer
    "ko",  # Korean
    "ky",  # Kyrgyz
    "lo",  # Lao
    "ms",  # Malay
    "my",  # Burmese
    "sah", # Yakut
    "su",  # Sundanese
    "th",  # Thai
    "tt",  # Tatar
    "ug",  # Uyghur
    "vi",  # Vietnamese
    "wo",  # Wolof
    "zh",  # Chinese [2]
  ]

  @two_forms_1 Enum.uniq [
    "af",    # Afrikaans
    "an",    # Aragonese
    "anp",   # Angika
    "as",    # Assamese
    "ast",   # Asturian
    "az",    # Azerbaijani
    "bg",    # Bulgarian
    "bn",    # Bengali
    "brx",   # Bodo
    "ca",    # Catalan
    "da",    # Danish
    "de",    # German
    "doi",   # Dogri
    "el",    # Greek
    "en",    # English
    "eo",    # Esperanto
    "es",    # Spanish
    "es_AR", # Argentinean Spanish
    "et",    # Estonian
    "eu",    # Basque
    "ff",    # Fulah
    "fi",    # Finnish
    "fo",    # Faroese
    "fur",   # Friulian
    "fy",    # Frisian
    "gl",    # Galician
    "gu",    # Gujarati
    "ha",    # Hausa
    "he",    # Hebrew
    "hi",    # Hindi
    "hne",   # Chhattisgarhi
    "hy",    # Armenian
    "hu",    # Hungarian
    "ia",    # Interlingua
    "it",    # Italian
    "kl",    # Greenlandic
    "kn",    # Kannada
    "ku",    # Kurdish
    "lb",    # Letzeburgesch
    "mai",   # Maithili
    "ml",    # Malayalam
    "mn",    # Mongolian
    "mni",   # Manipuri
    "mr",    # Marathi
    "nah",   # Nahuatl
    "nap",   # Neapolitan
    "nb",    # Norwegian Bokmal
    "ne",    # Nepali
    "nl",    # Dutch
    "se",    # Northern Sami
    "nn",    # Norwegian Nynorsk
    "no",    # Norwegian (old code)
    "nso",   # Northern Sotho
    "or",    # Oriya
    "ps",    # Pashto
    "pa",    # Punjabi
    "pap",   # Papiamento
    "pms",   # Piemontese
    "pt",    # Portuguese
    "rm",    # Romansh
    "rw",    # Kinyarwanda
    "sat",   # Santali
    "sco",   # Scots
    "sd",    # Sindhi
    "si",    # Sinhala
    "so",    # Somali
    "son",   # Songhay
    "sq",    # Albanian
    "sw",    # Swahili
    "sv",    # Swedish
    "ta",    # Tamil
    "te",    # Telugu
    "tk",    # Turkmen
    "ur",    # Urdu
    "yo",    # Yoruba
  ]

  @two_forms_2 Enum.uniq [
    "ach",   # Acholi
    "ak",    # Akan
    "am",    # Amharic
    "arn",   # Mapudungun
    "br",    # Breton
    "fil",   # Filipino
    "fr",    # French
    "gun",   # Gun
    "ln",    # Lingala
    "mfe",   # Mauritian Creole
    "mg",    # Malagasy
    "mi",    # Maori
    "oc",    # Occitan
    "pt_BR", # Brazilian Portuguese
    "tg",    # Tajik
    "ti",    # Tigrinya
    "tr",    # Turkish
    "uz",    # Uzbek
    "wa",    # Walloon
  ]

  @three_forms_slavic Enum.uniq [
    "be", # Belarusian
    "bs", # Bosnian
    "hr", # Croatian
    "sr", # Serbian
    "ru", # Russian
    "uk", # Ukrainian
  ]

  @three_forms_slavic_alt Enum.uniq [
    "cs", # Czech
    "sk", # Slovak
  ]

  # Number of plural forms.

  def nplurals(locale)

  for l <- @one_form do
    def nplurals(unquote(l)), do: 1
  end

  for l <- @two_forms_1 ++ @two_forms_2 do
    def nplurals(unquote(l)), do: 2
  end

  for l <- @three_forms_slavic ++ @three_forms_slavic_alt do
    def nplurals(unquote(l)), do: 3
  end

  # Custom number of plural forms.

  # Arabic
  def nplurals("ar"), do: 6

  # Kashubian
  def nplurals("csb"), do: 3

  # Welsh
  def nplurals("cy"), do: 4

  # Irish
  def nplurals("ga"), do: 5

  # Scottish Gaelic
  def nplurals("gd"), do: 4

  # Icelandic
  def nplurals("is"), do: 2

  # Javanese
  def nplurals("jv"), do: 2

  # Cornish
  def nplurals("kw"), do: 4

  # Lithuanian
  def nplurals("lt"), do: 3

  # Latvian
  def nplurals("lv"), do: 3

  # Macedonian
  def nplurals("mk"), do: 3

  # Mandinka
  def nplurals("mnk"), do: 3

  # Maltese
  def nplurals("mt"), do: 4

  # Polish
  def nplurals("pl"), do: 3

  # Romanian
  def nplurals("ro"), do: 3

  # Slovenian
  def nplurals("sl"), do: 4

  # Plural form of groupable languages.

  def plural(locale, count)

  for l <- @one_form do
    def plural(unquote(l), _n), do: 0
  end

  for l <- @two_forms_1 do
    def plural(unquote(l), 1), do: 0
    def plural(unquote(l), _n), do: 1
  end

  for l <- @two_forms_2 do
    def plural(unquote(l), n) when n in [0, 1], do: 0
    def plural(unquote(l), _n), do: 1
  end

  for l <- @three_forms_slavic do
    def plural(unquote(l), n)
      when ends_in(n, 1) and n != 11,
      do: 0
    def plural(unquote(l), n)
      when ends_in(n, [2, 3, 4]) and (rem(n, 100) < 10 or rem(n, 100) >= 20),
      do: 1
    def plural(unquote(l), _n),
      do: 2
  end

  for l <- @three_forms_slavic_alt do
    def plural(unquote(l), 1), do: 0
    def plural(unquote(l), n) when n in 2..4, do: 1
    def plural(unquote(l), _n), do: 2
  end

  # Custom plural forms.

  # Arabic
  # n==0 ? 0 : n==1 ? 1 : n==2 ? 2 : n%100>=3 && n%100<=10 ? 3 : n%100>=11 ? 4 : 5
  def plural("ar", 0), do: 0
  def plural("ar", 1), do: 1
  def plural("ar", 2), do: 2
  def plural("ar", n) when rem(n, 100) >= 3 and rem(n, 100) <= 10, do: 3
  def plural("ar", n) when rem(n, 100) >= 11, do: 4
  def plural("ar", _n), do: 5

  # Kashubian
  # (n==1) ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2;
  def plural("csb", 1),
    do: 0
  def plural("csb", n)
    when ends_in(n, [2, 3, 4]) and (rem(n, 100) < 10 or rem(n, 100) >= 20),
    do: 1
  def plural("csb", _n),
    do: 2

  # Welsh
  # (n==1) ? 0 : (n==2) ? 1 : (n != 8 && n != 11) ? 2 : 3
  def plural("cy", 1), do: 0
  def plural("cy", 2), do: 1
  def plural("cy", n) when n != 8 and n != 11, do: 2
  def plural("cy", _n), do: 3

  # Irish
  # n==1 ? 0 : n==2 ? 1 : (n>2 && n<7) ? 2 :(n>6 && n<11) ? 3 : 4
  def plural("ga", 1), do: 0
  def plural("ga", 2), do: 1
  def plural("ga", n) when n in 3..6, do: 2
  def plural("ga", n) when n in 7..10, do: 3
  def plural("ga", _n), do: 4

  # Scottish Gaelic
  # (n==1 || n==11) ? 0 : (n==2 || n==12) ? 1 : (n > 2 && n < 20) ? 2 : 3
  def plural("gd", n) when n == 1 or n == 11, do: 0
  def plural("gd", n) when n == 2 or n == 12, do: 1
  def plural("gd", n) when n > 2 and n < 20, do: 2
  def plural("gd", _n), do: 3

  # Icelandic
  # n%10!=1 || n%100==11
  def plural("is", n) when ends_in(n, 10) and rem(n, 100) != 11, do: 0
  def plural("is", _n), do: 1

  # Javanese
  # n != 0
  def plural("jv", 0), do: 0
  def plural("jv", _), do: 1

  # Cornish
  # (n==1) ? 0 : (n==2) ? 1 : (n == 3) ? 2 : 3
  def plural("kw", 1), do: 0
  def plural("kw", 2), do: 1
  def plural("kw", 3), do: 2
  def plural("kw", _), do: 3

  # Lithuanian
  # n%10==1 && n%100!=11 ? 0 : n%10>=2 && (n%100<10 || n%100>=20) ? 1 : 2
  def plural("lt", n)
    when ends_in(n, 1) and rem(n, 100) != 11,
    do: 0
  def plural("lt", n)
    when rem(n, 10) >= 2 and (rem(n, 100) < 10 or rem(n, 100) >= 20),
    do: 1
  def plural("lt", _),
    do: 2

  # Latvian
  # n%10==1 && n%100!=11 ? 0 : n != 0 ? 1 : 2
  def plural("lv", n) when ends_in(n, 1) and rem(n, 100) != 11, do: 0
  def plural("lv", n) when n != 0, do: 1
  def plural("lv", _), do: 2

  # Macedonian
  # n==1 || n%10==1 ? 0 : 1; Can’t be correct needs a 2 somewhere
  def plural("mk", n) when ends_in(n, 1), do: 0
  def plural("mk", n) when ends_in(n, 2), do: 1
  def plural("mk", _), do: 2

  # Mandinka
  # n==0 ? 0 : n==1 ? 1 : 2
  def plural("mnk", 0), do: 0
  def plural("mnk", 1), do: 1
  def plural("mnk", _), do: 2

  # Maltese
  # n==1 ? 0 : n==0 || ( n%100>1 && n%100<11) ? 1 : (n%100>10 && n%100<20 ) ? 2 : 3
  def plural("mt", 1), do: 0
  def plural("mt", n) when n == 0 or (rem(n, 100) > 1 and rem(n, 100) < 11), do: 1
  def plural("mt", n) when rem(n, 100) > 10 and rem(n, 100) < 20, do: 2
  def plural("mt", _), do: 3

  # Polish
  # n==1 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2
  def plural("pl", 1),
    do: 0
  def plural("pl", n)
    when ends_in(n, [2, 3, 4]) and (rem(n, 100) < 10 or rem(n, 100) >= 20),
    do: 1
  def plural("pl", _),
    do: 2

  # Romanian
  # n==1 ? 0 : (n==0 || (n%100 > 0 && n%100 < 20)) ? 1 : 2
  def plural("ro", 1), do: 0
  def plural("ro", n) when n == 0 or (rem(n, 100) > 0 and rem(n, 100) < 20), do: 1
  def plural("ro", _), do: 2

  # Slovenian
  # n%100==1 ? 1 : n%100==2 ? 2 : n%100==3 || n%100==4 ? 3 : 0
  def plural("sl", n) when rem(n, 100) == 1, do: 1
  def plural("sl", n) when rem(n, 100) == 2, do: 2
  def plural("sl", n) when rem(n, 100) == 3, do: 3
  def plural("sl", _), do: 0
end

