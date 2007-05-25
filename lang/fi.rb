Localization.define('en_US') { |l|
}
Localization.define('fi') do |l|
  l.store 'Collapse all', 'Pienennä kaikki'
  l.store 'Expand all', 'Suurenna kaikki'
  l.store 'Balance', 'Saldo'
  l.store 'balance', 'saldo'
  l.store 'Budget', 'Budjetti'
  l.store 'Status', 'Tilanne'
  l.store 'Totals', 'Yhteensä'
  l.store 'New account', 'Luo uusi tili'
	l.store 'Actions', 'Toiminnot'

  # script/../config/../config/../app/views/accounts/list.rhtml
  l.store 'Listing accounts', 'Tililuettelo'
  l.store 'General ledger', 'Pääkirja'
  l.store 'Daily ledger', 'Päiväkirja'
  l.store 'Income & balance sheet', 'Tulos ja tase'
  l.store 'Select fiscal period', 'Valitse tilikausi'
  l.store 'Search', 'Etsi'
  l.store 'Print', 'Tulosta'

  # script/../config/../config/../app/views/accounts/autocomplete_type_id.rhtml

  # script/../config/../config/../app/views/accounts/balance.rtex
  l.store 'Income and balance sheet', 'Tuloslaskelma ja tase'
  l.store 'Incomes', 'Tuloslaskelma'
  l.store 'Net income (loss)', 'Tilikauden voitto (tappio)'
  l.store 'Assets and liabilities', 'Taseen loppusumma'

  # script/../config/../config/../app/views/accounts/ledger.rtex
  l.store 'General ledger', 'Pääkirja'
	l.store 'Date', 'Päivä'
	l.store 'Receipt', 'Tosite'
  l.store 'Description', 'Selitys'
  l.store 'Debit', 'Debet'
  l.store 'Credit', 'Kredit'
	l.store 'Account', 'Vastatili'
  l.store 'Running sums', 'Välisummat'
  l.store 'This period', 'Tämä kausi'
  l.store 'Balance', 'Saldo'
  l.store 'From start', 'Alusta lähtien'

  # script/../config/../config/../app/views/accounts/show.rhtml
  l.store 'Edit', 'Muokkaa'
  l.store 'Back', 'Takaisin'
  l.store 'Parent', 'Ylätili'
  l.store 'Debet', 'Debet'
  l.store 'Show', 'Näytä'
  l.store 'Total', 'Yhteensä'
  l.store 'Credit', 'Kredit'
  l.store 'Status now', 'Tilanne nyt'

  # script/../config/../config/../app/views/accounts/_form.rhtml
  l.store 'Name', 'Nimi'
  l.store 'Number', 'Numero'
  l.store 'Description', 'Selite'
  l.store 'Account type', 'Tilin tyyppi'
  l.store 'Parent account', 'Ylätili'
	l.store 'Fiscal period', 'Tilikausi'

  # script/../config/../config/../app/views/accounts/edit.rhtml
  l.store 'Editing account', 'Tilin muokkaus'


  # script/../config/../config/../app/views/accounts/new.rhtml
  l.store 'Create', 'Luo'

  # script/../config/../config/../app/views/accounts/_list_account.rhtml
  l.store 'Are you sure?', 'Oletko varma?'

  # script/../config/../config/../app/views/users/new.rhtml
  l.store 'New User', 'Uusi käyttäjä'
  l.store 'New user', 'Luo uusi käyttäjä'

  # script/../config/../config/../app/views/users/list.rhtml
  l.store 'Listing users', 'Käyttäjälista'
  l.store 'Last logon at', 'Edellinen kirjautuminen'
  l.store 'Log in', 'Kirjaudu sisään'
  l.store 'Logout', 'Kirjaudu ulos'

  # script/../config/../config/../app/views/users/show.rhtml

  # script/../config/../config/../app/views/users/_form.rhtml
  l.store 'Login', 'Käyttäjätunnus'
  l.store 'Email', 'Sähköposti'
  l.store 'Level', 'Taso'
	l.store 'Offical', 'Toimihenkilö'
	l.store 'Board member', 'Hallituslainen'
  l.store 'Treasurer', 'Rahastonhoitaja'
  l.store 'Password', 'Salasana'
  l.store 'Password confirmation', 'Salasana uudestaan'
	l.store 'Created at', 'Luotu'

  # script/../config/../config/../app/views/users/edit.rhtml
  l.store 'Editing user', 'Muokkaa käyttäjää'


  # script/../config/../config/../app/views/budgets/list.rhtml
  l.store 'Listing budgets', 'Budjetit'

  # script/../config/../config/../app/views/budgets/show.rhtml
  l.store 'Budget accounts', 'Budjetin tilit'
  l.store 'Amount', 'Summa'
  l.store 'Save', 'Tallenna'

  # script/../config/../config/../app/views/budgets/new.rhtml
  l.store 'New budget', 'Uusi budjetti'

  # script/../config/../config/../app/views/budgets/edit.rhtml
  l.store 'Editing budget', 'Muokkaa budjettia'

  # script/../config/../config/../app/views/entries/list.rhtml
  l.store 'Listing entries', 'Tilitapahtumat'

  # script/../config/../config/../app/views/entries/show.rhtml

  # script/../config/../config/../app/views/entries/_entry.rhtml
  l.store 'Receipt number', 'Tosite'
  l.store 'Sum', 'Summa'
  l.store 'Date', 'Päiväys'
  l.store 'Debet account', 'Debet-tili'
  l.store 'Credit account', 'Kredit-tili'
  l.store 'Add entry', 'Lisää tapahtuma'

  # script/../config/../config/../app/views/entries/new.rhtml
  l.store 'New entry', 'Uusi tapahtuma'

  # script/../config/../config/../app/views/entries/ledger.rtex
  l.store 'Daily ledger', 'Päiväkirja'

  # script/../config/../config/../app/views/help/index.rhtml
  l.store 'Documents', 'Dokumentit'


	l.store 'Change', 'Vaihda'
	l.store 'Help', 'Apua'
	l.store 'Users', 'Käyttäjät'
	l.store 'Entries', 'Tilitapahtumat'
	l.store 'Invoices', 'Laskut'
	l.store 'Budgets', 'Budjetit'
	l.store 'Accounts', 'Tilit'


end
	           
