## Martian News Reader Application

You've been assigned the task of creating a translation of the New York Times news reader application for the latest emerging market -- Mars!  Luckily for you, the rules of translating English into Martian are pretty straightforward:

* all words greater than 3 characters should be translated to the word "boinga"
* capitalization must be maintained
* punctuation within words (e.g. we'll) can be discarded, all other punctuation must be maintained.

Please complete the attached application by implementing the following requirements:

* Dynamically retrieve a plist which contains the content for one or more articles from http://mobile.public.ec2.nytimes.com.s3-website-us-east-1.amazonaws.com/candidates/content/v1/articles.plist
* Display the translated content using 2 screens: a list of articles and an article view. It should recognize how many articles are in the given plist file and show them in a list. Tapping on a single article should then switch to the second screen and show the article page.
* Display one image per article, the "top image" from the feed. The image should be loaded lazily and displayed on both the list screen and the article screen. All other images may be discarded.
* Do not use UIWebViews
* Add as much code as you need via additional classes and/or methods; the only given code you can remove is where the application is raising exceptions.
* The given test case must pass; additional test cases should also be implemented as needed.
* Add a toggle so that Martians can choose to read the article either in English or Martian. Persist this preference.

The length of time spent to complete this exercise will not affect our evaluation. We understand that you are likely to have many things, both personally and professionally, that may slow you down. Your code will, however, be evaluated for style, simplicity and approach.

We will not answer any questions during the execution of this test so please document any assumptions you make about the requirements.

Thank you and good luck!

The NYT Mobile Team
