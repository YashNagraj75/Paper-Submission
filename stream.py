import streamlit as st
import pandas as pd

# Placeholder data to simulate database tables
authors_data = []
papers_data = []
reviews_data = []
schedule_data = []

# Streamlit app
st.title("GlobalTech Conference Paper Submission and Review System")

# Tabs for different sections
menu = ["Author Login", "Author Management", "Paper Submission", "Review Management", "Schedule"]
choice = st.sidebar.selectbox("Navigation", menu)

if choice == "Author Login":
    st.header("Author Login")
    with st.form("login_form"):
        username = st.text_input("Username")
        password = st.text_input("Password", type="password")
        login_button = st.form_submit_button("Login")

        if login_button:
            if username and password:  # Simple check for demonstration purposes
                st.success("Login successful!")
            else:
                st.error("Please provide both username and password.")

# Author Signup Page
elif choice == "Author Management":
    st.header("New Author Signup")
    with st.form("signup_form"):
        new_username = st.text_input("New Username")
        new_password = st.text_input("New Password", type="password")
        email = st.text_input("Email")
        affiliation = st.text_input("Affiliation")
        signup_button = st.form_submit_button("Sign Up")

        # Email validation
        import re
        def is_valid_email(email):
            email_regex = r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'
            return re.match(email_regex, email)

        if signup_button:
            if new_username and new_password and email and affiliation:
                if is_valid_email(email):
                    st.success(f"Author '{new_username}' registered successfully!")
                else:
                    st.error("Please enter a valid email address.")
            else:
                st.error("Please fill out all fields.")
elif choice == "Paper Submission":
    st.header("Submit a Paper")

    # List of available tracks for the dropdown
    tracks = ["Track A - Machine Learning", "Track B - Natural Language Processing", "Track C - Computer Vision", "Track D - Human-Computer Interaction"]

    # Paper form
    with st.form("paper_form"):
        title = st.text_input("Paper Title")
        abstract = st.text_area("Abstract")
        keywords = st.text_input("Keywords")
        submission_date = st.date_input("Submission Date")
        track = st.selectbox("Track", tracks)
        
        submit_paper = st.form_submit_button("Submit Paper")
        
        if submit_paper:
            papers_data.append({"ID": len(papers_data) + 1, "Title": title, "Abstract": abstract, "Keywords": keywords, "Date": submission_date, "Track": track})
            st.success(f"Paper '{title}' submitted successfully!")

    # Display papers
    st.subheader("Submitted Papers")
    if papers_data:
        papers_df = pd.DataFrame(papers_data)
        st.dataframe(papers_df)
    else:
        st.write("No papers submitted yet.")

elif choice == "Review Management":
    st.header("Manage Reviews")
    # Review form
    with st.form("review_form"):
        paper_id = st.number_input("Paper ID", min_value=1, step=1)
        reviewer_id = st.number_input("Reviewer ID", min_value=1, step=1)
        score_originality = st.slider("Score", 1, 100)
        feedback = st.text_area("Feedback")
        submit_review = st.form_submit_button("Submit Review")
        
        if submit_review:
            reviews_data.append({"ID": len(reviews_data) + 1, "Paper ID": paper_id, "Reviewer ID": reviewer_id, "Originality": score_originality, "Relevance": score_relevance, "Quality": score_quality, "Feedback": feedback})
            st.success(f"Review for Paper ID {paper_id} submitted successfully!")

    # Display reviews
    st.subheader("Reviews")
    if reviews_data:
        reviews_df = pd.DataFrame(reviews_data)
        st.dataframe(reviews_df)
    else:
        st.write("No reviews submitted yet.")

elif choice == "Schedule":
    st.header("Schedule Presentations")
    # Schedule form
    with st.form("schedule_form"):
        paper_id = st.number_input("Paper ID", min_value=1, step=1)
        presentation_time = st.text_input("Presentation Time")
        location = st.text_input("Location")
        submit_schedule = st.form_submit_button("Schedule Presentation")
        
        if submit_schedule:
            schedule_data.append({"ID": len(schedule_data) + 1, "Paper ID": paper_id, "Time": presentation_time, "Location": location})
            st.success(f"Paper ID {paper_id} scheduled for presentation!")

    # Display schedule
    st.subheader("Presentation Schedule")
    if schedule_data:
        schedule_df = pd.DataFrame(schedule_data)
        st.dataframe(schedule_df)
    else:
        st.write("No presentations scheduled yet.")
