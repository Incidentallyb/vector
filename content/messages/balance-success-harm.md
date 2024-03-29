---
title: Balance success harm
author: AL
triggered_by:
  - init|start|macaques|step|stay|feedback|score|step
  - init|start|pigs|increase|feedback|score|step
  - init|start|pigs|keep|feedback|score|step
  - init|start|mice|macaques|feedback|score|step
  - init|start|mice|fish|feedback|score|step
  - init|start|mice|pigs|feedback|score|step
  - init|start|mice|inhouse|feedback|score|step
  - init|start|mice|offsite|feedback|score|step
  - init|start|fish|adult|feedback|score|step
  - init|start|fish|embryo|feedback|score|step
  - init|start|macaques|step|change|step|pigs|feedback|score|step
  - init|start|macaques|step|change|step|mice|feedback|score|step
  - init|start|macaques|step|change|step|fish|feedback|score|step
choices:
  - scale|Scale up
  - phased|Learn from phased experiments
  - share|Collaborate with a competitor
scoreChangeEconomic:
  - scale|-2
  - phased|-1
  - share|-3
scoreChangeHarm:
  - scale|3
  - phased|-1
  - share|-2
scoreChangeSuccess:
  - scale|10
  - phased|5
  - share|5
---

You have been making some very difficult decisions so far, and your experiments are starting to show results.

To keep the balance of success vs harm, we have a few options for you, each will affect your success and harm rating.

Would you like to:

**Scale up** your work by doing more experiments involving more animals now. It will involve more harm, but you could get results faster. Cost: £2,000,000

Set up some more experiments in a **phased** way so that you learn from each experiment as you go. It could reduce harm, but it would take longer to get results. Cost: £1,000,000

**Collaborate** with a BioCore competitor so that you can share both your past data and biomatter. It would reduce harm, but you would lose some economic benefits. Cost: £3,000,000

Think about your decision, and let me know when you're ready to answer.
