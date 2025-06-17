import api from './api'

export const criarProduto = async (produto: any) => {
  const response = await api.post('/produtos', produto)
  return response.data
}

export const atualizarProduto = async (id: any, produto: any) => {
  const response = await api.put(`/produtos/${id}`, produto)
  return response.data
}

export async function deletarProduto(id: number): Promise<void> {
  await api.delete(`/produtos/${id}`)
}

export const pegarNovoCodigo = async (): Promise<string> => {
  const response = await api.get('/produtos/gerarCodigo')
  return response.data
}

export async function listarProdutos(params: Record<string, any> = {}) {
  const response = await api.get('/produtos', { params })
  return response.data
}
