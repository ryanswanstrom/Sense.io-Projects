!pip install webhose

import webhose
webhose.config(token=os.environ["WEBHOSE_KEY"])

## Just make a call
#posts = webhose.search("Obama performance_score:>8")



q = webhose.Query()
#q.some_terms = ['"big data"','"machine learning"']
#q.title = '"big data" OR "machine learning"'
q.phrase = '"data science" OR "machine learning"'
print q.query_string()

results = webhose.search(q.query_string() + ' performance_score:>1')

for post in results.posts:
  score = post.thread.performance_score
  if (score > 0):
    print(post.title + ' by ' + post.thread.site + ' with score ' + str(score))
    #print(post.thread.main_image)
    
 