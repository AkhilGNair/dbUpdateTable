model_People = data.table::data.table(
  PersonID = integer(0),
  LastName = character(0),
  FirstName = character(0),
  Age = numeric(0),
  key = c("PersonID", "LastName")
)

dt_people = data.table::copy(model_People)

# dt_people = dt_people %>% dbCreateTable::add(1, "LastName1", "Akhil")

one_all_unnamed_ordered = dt_people %>% dbCreateTable::add(2, "LastName3", "Chris",  65)
one_all_named_unordered = dt_people %>% dbCreateTable::add(PersonID = 3, FirstName = "Melody", LastName = "LastName4", Age = 26)
one_few_named           = dt_people %>% dbCreateTable::add(PersonID = 4, LastName = "LastName5", Age = 21)
mult_few_named_list     = dt_people %>% dbCreateTable::add(list(PersonID = c(1, 7), LastName = c("LastName1", "LastName7")))
one_unnamed_list        = dt_people %>% dbCreateTable::add(list(6, "LastName6", "Tom", 30))
