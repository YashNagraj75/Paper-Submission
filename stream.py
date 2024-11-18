import errno
import streamlit as st
import pandas as pd
import re
from data import author_login,author_signup, get_presentation_details,submit_new_paper,get_user_id,get_papers_by_user,update_paper_details
from schema import Paper_Submit

# Initialize session state for login, role, and current page
if 'logged_in' not in st.session_state:
    st.session_state.logged_in = False
if 'role' not in st.session_state:
    st.session_state.role = None
if 'current_page' not in st.session_state:
    st.session_state.current_page = 'Login'

# Email validation function
def is_valid_email(email):
    email_regex = r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$'
    return re.match(email_regex, email)

# Login form
if st.session_state.current_page == 'Login':
    st.header("Login Page")
    username = st.text_input("Username")
    password = st.text_input("Password", type="password")
    login_button = st.button("Login")

    if login_button:
        # Add your login logic here
        login = author_login(username,password)
        if login =="Author":
            st.session_state.logged_in = True
            st.session_state.role = "Author"
            st.session_state.current_page = 'Paper Submission'
            st.success("Logged in as Author")
        elif login == "Reviewer":
            st.session_state.logged_in = True
            st.session_state.role = "Reviewer"
            st.success("Logged in as Reviewer")

        else:
            st.error("Invalid credentials")


# Author pages
if st.session_state.logged_in and st.session_state.role == "Author":
    st.header("Author Dashboard")
    
    # Create tabs for navigation
    tab1, tab2, tab3 = st.tabs(["Paper Submission", "Edit Paper", "Submitted Papers"])

    with tab1:
        st.subheader("Submit a Paper")

        # List of available tracks for the dropdown
        tracks = ["Track A - Machine Learning", "Track B - Natural Language Processing", "Track C - Computer Vision", "Track D - Human-Computer Interaction"]

        # Paper form
        with st.form("paper_form"):
            title = st.text_input("Paper Title")
            abstract = st.text_area("Abstract")
            keywords = st.text_input("Keywords")
            submission_date = st.date_input("Submission Date")
            track = st.selectbox("Track", tracks)
            
            submit = st.form_submit_button("Submit Paper")
            
            if submit:
                # Add your paper submission logic here
                paper_obj = Paper_Submit(title=title, abstract=abstract, keywords=keywords, submission_date=str(submission_date), track=track)
                paper = submit_new_paper(paper_obj)
                presentation_details = get_presentation_details(title)
                if paper:
                    st.success("Paper submitted successfully!")
                    if presentation_details:
                        st.table(presentation_details)
                    else:
                        st.error("Paper not accepted")
                else:
                    st.error("Paper not submitted")

    with tab2:
        st.subheader("Edit Paper Details")
        with st.form("edit_paper_form"):
            paper_id = st.selectbox("Select Paper ID to Edit", ["1","2"])
            new_title = st.text_input("New Title")
            new_keywords = st.text_input("New Keywords")
            submit_edit = st.form_submit_button("Submit Changes")
            
            if submit_edit:
                update = update_paper_details(paper_id, new_title, new_keywords)
                if update == True:
                    st.success(f"Paper ID {paper_id} updated successfully!")
                else:
                    st.error(f"{update}")


    with tab3:
        st.subheader("Submitted Papers")
        
        username = st.text_input("Name")
        user_id = get_user_id(username)
        if st.button("Search"):
            if user_id:
                papers = get_papers_by_user(user_id)
                print(papers)
                if papers:
                    papers_df = pd.DataFrame(papers, columns=["PaperID", "Title", "Keywords","SubmissionDate","Track"])
                    st.table(papers_df)
            else:
                st.write("User not found.")



# Reviewer pages with navigation bar
if st.session_state.logged_in and st.session_state.role == "Reviewer":
    st.sidebar.title("Navigation")
    choice = st.sidebar.selectbox("Go to", ["Review Management", "Schedule"])

    if choice == "Review Management":
        st.header("Manage Reviews")
        # Review form
        with st.form("review_form"):
            paper_id = st.number_input("Paper ID", min_value=1, step=1)
            reviewer_id = st.number_input("Reviewer ID", min_value=1, step=1)
            score_originality = st.slider("Score", 1, 100)
            feedback = st.text_area("Feedback")
            submit_review = st.form_submit_button("Submit Review")
            
            if submit_review:
                # Add your review submission logic here
                st.success(f"Review for Paper ID {paper_id} submitted successfully!")

        # Display reviews
        st.subheader("Reviews")
        reviews_data = []  # Replace with actual data fetching logic
        if reviews_data:
            reviews_df = pd.DataFrame(reviews_data)
            st.dataframe(reviews_df)
        else:
            st.write("No reviews submitted yet.")


    if st.sidebar.button("Logout"):
        st.session_state.logged_in = False
        st.session_state.role = None
        st.session_state.current_page = 'Login'

