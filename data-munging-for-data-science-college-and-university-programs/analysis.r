# Setup
# -----
#
# The [sense library](https://github.com/SensePlatform/sense-r-module) includes
# a number of helper functions you can use from within R dashboards.

library('sense')


## Load Data
# Download the data from [Data Science Community](http://datascience.community/colleges)

#system('wget -nc http://datascience.community/colleges.csv')
# right here I performed some data cleanup
# Oakland University is in Mighigan
# Polytechnic University Of Turin is in IT not US
dsc_colleges <- read.csv('colleges.csv')
head(dsc_colleges)
summary(dsc_colleges)
str(dsc_colleges)

## Load Data from [Masters in Data Science](http://www.mastersindatascience.org/schools/)
# This process does some web scraping.  Huge thank you to 
# [Shivam Rana](https://twitter.com/TrigonaMinima) for providing
# the [source code for the web scraping](https://goo.gl/5wXcOJ).

install.packages('rvest')
library("rvest")

url <- "http://www.mastersindatascience.org/schools/"

webpage <- html(url)

links <- html_nodes(webpage, ".state a")

# Links of each state page.
page_urls <- html_attr(links, "href")

# pages <- vector(mode = "list", length = length(df$url))
schools_t <- vector(mode = "list", length = length(page_urls))

# Get the html of all stage pages and extract the html of
# school listings on each page.
for (i in (1:length(page_urls))) {
    schools_t[[i]] <- html_nodes(html(page_urls[i]), ".schoolinfo")
}


# Extracts the details of each program-
# Department, Cost, Curriculum, Pre Requisite Coursework, Delivery, Length.
coursedetails <- function(program, j) {
    programname <- html_text(html_node(program, "a"))
    url <- html_attr(html_node(program, "a"), "href")

    details <- html_nodes(program, ".programdetails .detail")

    department <- html_text(html_node(details[1], ".detailvalue"))
    cost <- html_attr(html_node(details[2], ".detailvalue a"), "href")
    curriculum <- html_attr(html_node(details[3], ".detailvalue a"), "href")
    prereqcoursework <- html_text(html_node(details[4], ".detailvalue"))
    delivery <- html_text(html_node(details[5], ".detailvalue"))
    length <- html_text(html_node(details[6], ".detailvalue"))

    row <- c(programname,
        url,
        department,
        cost,
        curriculum,
        prereqcoursework,
        delivery,
        length)
    return(row)
}

# Main function which does all the heavy work. Extracts all the information
# and calls the "coursedetails" function and get back the details of each
# program offered. Then, writes the data frame in a csv.
courses <- function(schools_t) {
    courses_list <- data.frame(schoolName = character(),
        schoolLocation = character(),
        program = character(),
        url = character(),
        department = character(),
        cost = character(),
        curriculum = character(),
        prereqcoursework = character(),
        delivery = character(),
        length = character(),
        stringsAsFactors = F)

    j <- 1
    for (i in (1 : length(schools_t))) {
        school <- schools_t[[i]]
        for (l in (1 : length(school))) {
            schoolname <- html_text(html_node(school[l], ".schoolheader"))
            schoollocation <- html_text(html_node(school[l], ".schoollocation"))

            programs <- html_nodes(school[l], ".programs .schoolprogram")

            for (m in (1 : length(programs))) {
                details <- coursedetails(programs[m], j)
                print(j)

                courses_list[j, ] <- list(schoolname,
                    schoollocation,
                    details[1],
                    details[2],
                    details[3],
                    details[4],
                    details[5],
                    details[6],
                    details[7],
                    details[8])
                j <- j + 1
            }
        }
    }
    # print(courses_list)
    write.csv(courses_list, "colleges2.csv")
    return(courses_list)
}

mds_colleges = courses(schools_t)

mds_colleges$State = gsub('^(.+?), ', '', mds_colleges$schoolLocation) %>%
    match(state.name)
mds_colleges$State = state.abb[mds_colleges$State]
mds_colleges[is.na(mds_colleges$State),]$State = 'DC'
mds_colleges$State = factor(mds_colleges$State)
mds_colleges$Country = 'US'
mds_colleges$Country = factor(mds_colleges$Country)
mds_colleges$Degree = ifelse(grepl('certificate',mds_colleges$program, ignore.case = TRUE),'Certificate','Masters')
mds_colleges$City = gsub(', (.+?)$', '', mds_colleges$schoolLocation)

## Join the 2 lists
# outer join
all_colleges = merge(x=mds_colleges, y=dsc_colleges, by='url', all=TRUE)

## Set the correct columns
#### URL
all_colleges$URL = all_colleges$url

#### SCHOOL
all_colleges$SCHOOL = ifelse(is.na(all_colleges$schoolName),as.character(all_colleges$name) ,all_colleges$schoolName)

#### PROGRAM
all_colleges$PROGRAM = ifelse(is.na(all_colleges$program.x),as.character(all_colleges$program.y) ,as.character(all_colleges$program.x))

#### DEGREE
all_colleges$DEGREE = ifelse(is.na(all_colleges$degree),as.character(all_colleges$Degree) ,as.character(all_colleges$degree))
# B=Bachelors,M=Masters,D=Doctoral,C=Certificate
all_colleges$DEGREE = ifelse(all_colleges$DEGREE=='Certificate','C',
                             ifelse(all_colleges$DEGREE=='Bachelors','B',
                                    ifelse(all_colleges$DEGREE=='Masters','M','D')))

#### COUNTRY
all_colleges$COUNTRY = ifelse(is.na(all_colleges$country),as.character(all_colleges$Country) ,as.character(all_colleges$country))
                             
#### STATE
all_colleges$STATE = ifelse(is.na(all_colleges$state),as.character(all_colleges$State) ,as.character(all_colleges$state))

#### CITY
all_colleges$CITY = all_colleges$City

#### ONLINE
all_colleges$ONLINE = ifelse(is.na(all_colleges$delivery),
                             ifelse(all_colleges$online=='true','T','F' ),
                             ifelse(grepl('online',mds_colleges$delivery, ignore.case = TRUE),'T','F' )
                            )

#### ONCAMPUS
all_colleges$ONCAMPUS = ifelse(is.na(all_colleges$delivery),
                             ifelse(all_colleges$oncampus=='true','T','F' ),
                             ifelse(grepl('campus',mds_colleges$delivery, ignore.case = TRUE),'T','F' )
                            )

#### DEPARTMENT
all_colleges$DEPARTMENT = ifelse(is.na(all_colleges$department.x),as.character(all_colleges$department.y) ,as.character(all_colleges$department.x))


## Create the final Data Frame and sort
library('plyr')  # for the arrange() function

data_science_colleges = all_colleges[,c('SCHOOL',
                          'PROGRAM',
                          'DEGREE',
                          'ONLINE',
                          'ONCAMPUS',
                          'COUNTRY',
                          'STATE',
                          'CITY',
                          'DEPARTMENT',
                          'URL')]
attach(data_science_colleges)
data_science_colleges = arrange(data_science_colleges, desc(COUNTRY), STATE, SCHOOL )
detach(data_science_colleges)


## Write out the final CSV
write.csv(data_science_colleges, 
          "colleges_combined.csv", row.names=FALSE)
                             
## Then manually go through and remove duplicates