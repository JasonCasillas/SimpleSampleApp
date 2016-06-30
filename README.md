## Information on the overall design
* Used storyboard to decide on how to display the data, since there was no set design
* Went with a business card style for the basic information in the cells, and then a simple scrollView for the full information list
* Created views programmatically, as detailed in the requirements, but the Storyboard could still be used by wiring up the outlets
* I separated the user info in the JSON into 3 different objects because although they could all be stored in a User, it made more sense to me to split them up. Users could potentially share an address or a company
* There is a warning from the storyboards, which I would not typically ignore, but in this case, rather than delete them or use them to silence the warning, I've left them to show what I used to decide on the simple design
* Used simple labels for displaying full user data. Could have used a textview for freebies like tappable emails, URLs, and phone numbers. I liked the look of this, and there were no requirements to make the #'s or links tappable.

## Assumptions made
* Didn't know what data was required for a user, or would be guaranteed to always exist in the JSON. Since it all seemed to be there right now, I set the given IDs as not optional.

## Improvements you feel would be needed
* This is all dependent on the use case for the app, but validations on the data would be good to add
* UI for letting the app user know if errors occur (and way better UI in general)
* Would likely need to check if user info changed for a real app
* If later able to change user data from the app, would need to handle possibility of merge conflicts as well
* Handle users that share the same company or address to avoid duplication (if that is a possibility)
* Send data over https so I can remove the exception for app transport security (and because there's personally identifiable info)

