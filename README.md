# KinGa - Die App für ErzieherInnen

As part of the "Pushing-the-Limits Project" (PuLi) in the Elite Graduate Program Software Engineering at the Technical University of Munich (TUM), the Ludwig Maximilian University of Munich (LMU) and the University of Augsburg, we (Nadine Bachl [@awakeTooLong](https://www.github.com/awakeTooLong), Manfred Stoiber [@ManfredStoiber](https://www.github.com/ManfredStoiber)) have developed an app:

<p align="center">
  <br>
  <img src="https://github.com/ManfredStoiber/KinGa/assets/47210077/94df23c2-0c27-4bb2-b3a2-d6f79c60df03" width="75"/>
  <br>
  <b>KinGa - Die App für ErzieherInnen<b/>
</p>


## 🎯 Goal

Our app aims to make the daily work of nursery school teachers easier by digitizing and simplifying organizational tasks.

![overview](https://github.com/ManfredStoiber/KinGa/assets/47210077/854f1eba-dcda-48c0-adde-53704f4ec811)

## 📅 Current Situation

Currently, teachers handle a large number of tasks and face numerous challenges, such as:
- Keeping track of children's daily attendances, absences and sick days
- Finding and updating various information about each child
- Ensuring awareness of and adherence to specific permissions (e.g., running barefoot, photo permissions)
- Carrying and managing an emergency contact folder
- Completing psychological development forms
- Communicating important information
- Ensuring children are picked up by authorized persons only

Information is often scattered across various folders, documents and locations, making it time-consuming and labor-intensive to manage and access

## ⭐ Solutions and Features

To address these tasks and challenges, KinGa offers various features, including:

### 📁 Centralized Information
- All information is stored in one place for easy access
- Various permissions can be retrieved for groups or specific children
- Emergency contact numbers can be easily retrieved or directly called
- Color-coded overview indicates detailed attendance statuses (e.g., "not yet arrived", "reported sick")

### 📝 Record Keeping

- Sick days can be recorded for current or future dates
- Assistance for completing development sheets ("Entwicklungsbögen") is offered throughout the year
- One-click option to record attendances

### 🗣️ Communication

- Assists in more effective communication between differents shifts and to parents (e.g. note for parents visible on the child's page)
- Ensures children are picked up by authorized persons only

### 🔒 Security

All personal data is stored in encrypted form so that only the teachers have access to it via the app.
In order to provide the best possible benefit, the encrypted data needs to be synchronized between the devices of several educators, rooms or groups. This requires servers, which were hosted exclusively in Germany during the user study conducted in a large kindergarten in the Munich area.

### 🌐 Open Source

Because of the very positive feedback of the app, we had decided to continue this project outside of our studies in order to continue working on our vision of making the day-to-day life of educators easier. However, due to a lack of time because of other commitments, it is not possible for us to continue working on this project anymore. For this reason, we have decided to make our app available to the community as open source.

## KinGa KidZ
As described above, one essential but time-consuming task in kindergartens is tracking the attendance of children, so we came up with two ways to automate it.

### 🎒 RFID Keychains
- A hidden Long Range RFID reader is installed at the entrance 
- Each child has a keychain with an integrated RFID chip attached to the backpack (e.g. a cute stuffed animal)

### 🦁 RFID Figurines
- A playfully decorated RFID reader is placed near the entrance (the tree stump in our prototype)
- Each child has their own small animal figurine that they place on the stump upon arrival
- Upon successful recognition, the stump lights up and the figurine can be removed

Both approaches then automatically log their attendance in the app.

![IMG_20230323_144450](https://github.com/ManfredStoiber/KinGa/assets/47210077/146466b1-3a29-4109-bfc2-3a6f95ca660c)

## 🔍 Further Information

Additional details can be found in the final [presentation](https://github.com/ManfredStoiber/KinGa/docs/presentation.pdf) of the project.

