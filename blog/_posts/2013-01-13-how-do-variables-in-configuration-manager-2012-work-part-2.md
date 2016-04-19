---
id: 676
title: 'How do variables in Configuration Manager 2012 work? &ndash; Part 2'
date: 2013-01-13T02:05:00+00:00
author: "David O'Brien"
layout: post
guid: http://www.david-obrien.net/?p=676
permalink: /2013/01/how-do-variables-in-configuration-manager-2012-work-part-2/
categories:
  - ConfigMgr
  - ConfigMgr 2012
  - Configuration Manager
  - Microsoft
  - SCCM
  - System Center
  - System Center Configuration Manager
tags:
  - collection
  - ConfigMgr
  - Configuration Manager
  - Microsoft
  - SCCM
  - SCCM 2012
  - variables
---
This is part 2 of my little series about variables in Configuration Manager 2012, for part 1 read here: [http://www.david-obrien.net/?p=660](http://www.david-obrien.net/?p=660)

In part 1 I talked about setting variables on collections and machines directly.

## Using limited collections to set variables

In my opinion the approach in part 1 has a huge downside, you won’t be able to see the collection’s or machine’s complete configuration at a glance. If you look at the collection variables, you see what you configured on the collection. What if you have 100 collection members? You will have a hard time telling which of these members have which or any variables set on it. Administrating or troubleshooting is next to impossible. (at least without the help from scripts or console extensions)

One way you could go and I’m going to show you here is using ‘Limited collections’. This concept isn’t completely new, it reminds a bit of the concept of “subcollections” in ConfigMgr 2007.

All built-in collections are limited by the “All Systems” collection and this can, of course, not be changed.
  
While creating any new collection you’re being asked which collection the new one should be limited by.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="http://www.david-obrien.net/wp-content/uploads/2013/01/image_thumb2.png" alt="image" width="317" height="117" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/01/image2.png)Limiting collection means that machines, in order to be a member of the limited collection, need also to be a member of the limiting collection.

I created an example of how it could look like when using such limited collections.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="http://www.david-obrien.net/wp-content/uploads/2013/01/image_thumb3.png" alt="image" width="318" height="96" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/01/image3.png)
  
This way it’s possible to add machines to the “All Departments” collection and configure variables with default values for all departments in the company. Then I add all machines to their respective department collection and if needed configure any deviating variables on the collection, not the machine. In doing so it’s possible to spot the configuration of each machine just by looking at its collection membership and knowing what was configured on the collection.

Example:

<table width="400" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td valign="top" width="200">
      <strong>Collection</strong>
    </td>
    
    <td valign="top" width="200">
      <strong>variable | value</strong>
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="200">
      All Departments
    </td>
    
    <td valign="top" width="200">
      Department | none
    </td>
  </tr>
  
  <tr>
    <td valign="top" width="200">
      Finance
    </td>
    
    <td valign="top" width="200">
      Department | Finance
    </td>
  </tr>
</table>

True, maybe not the most creative example, but I guess you get the point. A machine that’s a member of the “All Departments” collection and the “Finance” collection will have the “Department” variable set to “Finance”.

## Not the whole truth – Priority is key

Every collection has a property called “Variable Priority”. By default this is set to the value “1”, means lowest. The highest value is “9”, highest.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="http://www.david-obrien.net/wp-content/uploads/2013/01/image_thumb4.png" alt="image" width="294" height="308" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/01/image4.png)

Any collection, a machine is member of, that has a higher priority, will overwrite these variables. The priority can only be set per collection, not per variable.

[<img style="background-image: none; float: none; padding-top: 0px; padding-left: 0px; margin-left: auto; display: block; padding-right: 0px; margin-right: auto; border: 0px;" title="image" src="http://www.david-obrien.net/wp-content/uploads/2013/01/image_thumb5.png" alt="image" width="296" height="313" border="0" />]("image" http://www.david-obrien.net/wp-content/uploads/2013/01/image5.png)

## Use of a generic Task Sequence

In part 1 I gave the example of a generic Task Sequence which would use variables for certain operations during OS deployment.
  
Using variables the way I described could help you for example when joining the domain.

If all Finance machines should be joining into a OU called “Finance”, one could write the LDAP path in the “Apply network settings” step like this:

[_LDAP://OU=%Department%,OU=Clients,DC=do,DC=local_](ldap://OU=%Department%,OU=Clients,DC=do,DC=local)

The Task Sequence would be deployed to the “All Departments” collection, because all the machines are hosted in this collection, and every machine would set the LDAP path to the required department’s OU.

## Limiting collections necessary?

No, but I like it that way, because now I can group my collections again by departments, by use-case or any other property I like.
  
One other way would be to use “includes” and not limiting collections.
  
Create a “parent collection” with all base variables, create other collections with their variables and use an “include membership rule” to add the “child collections” to the parent.

Part 3 will contain a little script to set the collection’s variable priority. 

<div style="float: right; margin-left: 10px;">
  [Tweet](https://twitter.com/share)
</div>

