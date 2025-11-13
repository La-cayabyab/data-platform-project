import logging
from src.endpoint_extractor.posts_extractor import extract_posts
from src.endpoint_extractor.comments_extractor import extract_comments
from src.endpoint_extractor.users_extractor import extract_users

def main():
    """ Run extractors."""
    logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s %(message)s')
    try:
        logging.info("Extracting posts...")
        extract_posts()
        logging.info("Extracting comments...")
        extract_comments()
        logging.info("Extracting users...")
        extract_users()
    except Exception as e:
        logging.exception(f"Extraction failed: {e}")

if __name__ == "__main__":
    main()
