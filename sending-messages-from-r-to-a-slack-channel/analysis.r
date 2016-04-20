library(sense)

# install bleeding edge slackr package
devtools::install_github("hrbrmstr/slackr")

library('slackr')

token <- Sys.getenv('SLACK_API_TOKEN')
slackrSetup(channel="#sense", api_token=token)

### Do some amazing analysis here

slackr('The results for R are finished')
slackr(str(iris))
