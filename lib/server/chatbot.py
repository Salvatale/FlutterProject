from langchain_community.vectorstores import Chroma
from langchain_community import embeddings
from langchain_community.llms import Ollama
from langchain_core.runnables import RunnablePassthrough
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import ChatPromptTemplate
import os



def process_input(question,persist_directory):

    if not os.path.exists(persist_directory):
        return "Invalid context, insert a valid context!!"
        

    db = Chroma(persist_directory=persist_directory, embedding_function=embeddings.OllamaEmbeddings(model='nomic-embed-text'))
    retriever = db.as_retriever()

    model_local = Ollama(model="mistral")
    
    #perform the RAG 
    
    question = "rispondi in italiano a: " + question

    after_rag_template = """Answer the question based only on the following context:
    {context}
    Question: {question}
    """
    after_rag_prompt = ChatPromptTemplate.from_template(after_rag_template)
    after_rag_chain = (
        {"context": retriever, "question": RunnablePassthrough()}
        | after_rag_prompt
        | model_local
        | StrOutputParser()
    )
    return after_rag_chain.invoke(question)