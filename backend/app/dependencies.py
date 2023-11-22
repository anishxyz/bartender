from typing import Optional

from fastapi import Header, HTTPException


def get_user_id(authorization: Optional[str] = Header(None)):
    if authorization is None:
        raise HTTPException(status_code=401, detail="Authorization header missing")
    # Assuming the user ID is directly in the Authorization header
    return authorization
