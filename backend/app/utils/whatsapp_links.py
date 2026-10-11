import urllib.parse

def generate_whatsapp_link(title: str, text_poem: str, phone_number: str = "") -> str:
    """
    Formatea un poema con un diseño poético/estético y genera el enlace 
    de WhatsApp (Deep Link) listo para enviar.
    """
    formatted_message = (
        f"🌙 *{title}* 🌙\n\n"
        f"{text_poem}\n\n"
        f"✨ _Enviado con Tinta de Luna_ ✨"
    )

    encoded_message = urllib.parse.quote(formatted_message)

    if phone_number:
        whatsapp_url = f"https://wa.me/{phone_number}?text={encoded_message}"
    else:
        whatsapp_url = f"https://wa.me/?text={encoded_message}"

    return whatsapp_url