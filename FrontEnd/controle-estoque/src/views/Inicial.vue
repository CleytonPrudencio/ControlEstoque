<template lang="pug">
  .main-container
    h1 Painel de Controle de Estoque
    .card
      h2 Entrada / Saída de Produto

      form(@submit.prevent="registrarMovimentacao")
        .form-row.centralizado

          .flex-1.produto-com-detalhes
            label Produto
            select(v-model="movimento.produtoId", required)
              option(value="" disabled selected) Selecione
              option(v-for="produto in produtos" :value="produto.id") {{ produto.nome }}

            .produto-detalhes(v-if="produtoSelecionado")
              small Código: {{ produtoSelecionado.codigo }}
              br
              small Tipo: {{ produtoSelecionado.tipo }}
              br
              small Estoque: {{ produtoSelecionado.quantidade }}
              br
              small Valor Fornecedor: {{ formatarReais(produtoSelecionado.valorFornecedor) }}
              br
              small Venda: {{ formatarReais(produtoSelecionado.valorVenda) }}


          .flex-1.tipo-toggle-wrapper
            label Tipo
            .tipo-toggle.centralizado
              button(
                :class="{ ativo: movimento.tipo === 'ENTRADA' }"
                type="button"
                @click="movimento.tipo = 'ENTRADA'"
              ) Entrada
              button(
                :class="{ ativo: movimento.tipo === 'SAIDA' }"
                type="button"
                @click="movimento.tipo = 'SAIDA'"
              ) Saída

        .form-row.centralizado(v-if="movimento.tipo === 'SAIDA'")
          div.flex-1.valor-wrapper
            label Valor de Venda
            .valor-formatado
              input(type="number" step="0.01" v-model.number="movimento.valor" required)
              span.valor-texto {{ formatarReais(movimento.valor) }}

        .form-row.centralizado
          div.flex-1.quantidade-wrapper
            label Quantidade
            .input-quantidade
              button.btn-quantidade(type="button" @click="diminuirQuantidade") –
              input(type="number" v-model.number="movimento.quantidade" min="1")
              button.btn-quantidade(type="button" @click="aumentarQuantidade") +

        .form-row.centralizado
          button.btn-submit(type="submit") Registrar
          button.btn-limpar(type="button" @click="limparFormulario") Limpar

        p.alert(v-if="erro") {{ erro }}
        p.success(v-if="sucesso") {{ sucesso }}

    .card
      h2 Lista de Produtos
      .filtros-produtos
        input(type="text" v-model="filtroProduto.codigo" placeholder="Filtrar por código")
        input(type="text" v-model="filtroProduto.descricao" placeholder="Filtrar por nome")
        select(v-model="filtroProduto.tipoProduto")
          option(value="") Todos os tipos
          option(value="ELETRONICO") Eletrônico
          option(value="ELETRODOMESTICO") Eletrodoméstico
          option(value="MOVEL") Móvel
        button.btn-outline(type="button" @click="limparFiltrosProduto") Limpar filtros
        button.btn-outline-gren(@click="abrirAdicionarProduto()") Adicionar Produto +
      table
        thead
          tr
            th Código
            th Produto
            th Tipo
            th Estoque
            th Saídas
            th Fornecedor (R$)
            th Ações
        tbody
          tr(
              v-for="produto in produtos"
              :key="produto.id"
              @click="abrirExtrato(produto.id)"
              style="cursor: pointer;"
            )
            td
              strong {{ produto.codigo }}
            td {{ produto.nome }}
            td {{ produto.tipo }}
            td {{ produto.quantidade }}
            td(v-if="!isLoading") {{ saidasPorProduto[produto.id] || 0 }}
            td {{ formatarReais(produto.valorFornecedor.toFixed(2)) }}
            td
              button.btn-outline(@click.stop="abrirEditar(produto)") Editar
              button.btn-outline-red(@click.stop="abrirConfirmarRemocao(produto)") Apagar

      .pagination
        button(:disabled="paginaProduto === 0" @click="buscarProdutos(paginaProduto - 1)") Anterior
        span Página {{ paginaProduto + 1 }} de {{ totalPaginasProduto }}
        button(:disabled="paginaProduto + 1 >= totalPaginasProduto" @click="buscarProdutos(paginaProduto + 1)") Próximo

    .card
      h2 Histórico de Movimentações
      .filtros-movimentacoes
        input(type="text" v-model="filtroMov.codigo" placeholder="Filtrar por código do produto")
        select(v-model="filtroMov.tipo")
          option(value="") Todos os tipos
          option(value="ENTRADA") Entrada
          option(value="SAIDA") Saída
          option(value="EXCLUSAO") Excluido

        input(type="date" v-model="filtroMov.dataInicio")
        input(type="date" v-model="filtroMov.dataFim")
        button.btn-outline(type="button" @click="limparFiltrosMovimentacoes") Limpar filtros
      table
        thead
          tr
            th Código
            th Produto
            th Tipo Produto
            th Tipo Movimentação
            th Quantidade
            th Valor Fornecedor (R$)
            th Valor Venda/Compra (R$)
            th Lucro (R$)
            th Data Venda/Entrada
        tbody
          tr(v-for="m in movimentacoes" :key="m.id")
            td
              strong {{ m.produto.codigo }}
            td {{ m.produto.descricao }}
            td {{ m.produto.tipoProduto }}
            td(:class="{'entrada': m.tipo === 'ENTRADA','saida': m.tipo === 'SAIDA','exclusao': m.tipo === 'EXCLUSAO'}") {{ m.tipo }}
            td {{ m.quantidade }}
            td {{ formatarReais(m.produto.valorFornecedor) }}
            td {{ m.valorVenda ? formatarReais(m.valorVenda) : '—' }}
            td {{ calcularLucro(m) }}
            td {{ m.dataVenda ? new Date(m.dataVenda).toLocaleDateString('pt-BR') : '—' }}
      .pagination
        button(:disabled="paginaMov === 0" @click="buscarMovimentacoes(paginaMov - 1)") Anterior
        span Página {{ paginaMov + 1 }} de {{ totalPaginasMov }}
        button(:disabled="paginaMov + 1 >= totalPaginasMov" @click="buscarMovimentacoes(paginaMov + 1)") Próximo

  ModalEditarProduto(
    v-if="modalEditarAberto"
    :produto="produtoSelecionado"
    @close="modalEditarAberto = false"
    @salvar="salvarProduto"
  )

  ModalConfirmarRemocao(
    v-if="modalRemocaoAberto"
    :produto="produtoSelecionado"
    @close="modalRemocaoAberto = false"
    @confirmar="confirmarRemocao"
  )

  ModalProduto(
    v-if="modalAberto"
    :produto="produtoParaEditar"
    @close="modalAberto = false"
    @salvar="salvarProduto"
  )

  ModalExtrato(
  v-if="modalExtratoAberto"
  :extrato="extratoProduto"
  @close="modalExtratoAberto = false"
  )

</template>

<script setup lang="ts">
import { ref, onMounted, computed, reactive, watch } from 'vue'
import {
  listarProdutos,
  criarProduto,
  atualizarProduto,
  deletarProduto
} from '@/services/produtoService'
import {
  listarMovimentacao,
  criarMovimentacao,
  listarExtratoPorProduto,
  listarResumoSaidas
} from '@/services/movimentacaoService'
import type { ExtratoProduto } from '@/services/movimentacaoService'

import { login } from '@/services/authService'
import ModalExtrato from '@/views/components/ModalExtrato.vue'

import ModalProduto from '@/views/components/ModalProdutoNovo.vue'
import ModalEditarProduto from '@/views/components/ModalEditarProduto.vue'
import ModalConfirmarRemocao from '@/views/components/ModalConfirmarRemocao.vue'

interface Produto {
  id: number
  codigo: string
  nome: string
  tipo: string
  quantidade: number
  valorFornecedor: number
  valorVenda: number
  saidas?: number
}

interface Movimento {
  produtoId: number | null
  tipo: 'ENTRADA' | 'SAIDA'
  quantidade: number
  valor: number
}

interface ProdutoMovimentado {
  id: number
  codigo: string
  descricao: string
  tipoProduto: string
  valorFornecedor: number
  quantidadeEstoque: number
}

interface Movimentacao {
  id: number
  produto: ProdutoMovimentado
  tipo: 'ENTRADA' | 'SAIDA'
  valorVenda: number | null
  dataVenda: string | null
  quantidade: number
}
const modalExtratoAberto = ref(false)
const extratoProduto = ref<ExtratoProduto | null>(null)
const modalEditarAberto = ref(false)
const modalRemocaoAberto = ref(false)
const produtoParaEditar = ref<Produto | null>(null)
const modalAberto = ref(false)
const produtos = ref<Produto[]>([])
const movimento = ref<Movimento>({
  produtoId: null,
  tipo: 'ENTRADA',
  quantidade: 1,
  valor: 0
})
const filtroProduto = reactive({
  codigo: '',
  descricao: '',
  tipoProduto: ''
})
const isLoading = ref(true)

const paginaProduto = ref(0)
const totalPaginasProduto = ref(1)

const filtroMov = reactive({
  tipo: '',
  codigo: '', // novo
  dataInicio: '',
  dataFim: ''
})

const paginaMov = ref(0)
const totalPaginasMov = ref(1)

const movimentacoes = ref<Movimentacao[]>([])
const erro = ref('')
const sucesso = ref('')
const saidasPorProduto = ref<Record<string, number>>({})

onMounted(async () => {
  isLoading.value = true
  try {
    const resultado = await listarResumoSaidas()
    saidasPorProduto.value = resultado
  } finally {
    isLoading.value = false
  }
})

const produtoSelecionado = ref<Produto | null>(null)

function formatarReais(valor: number | undefined): string {
  return valor == null
    ? '—'
    : new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(valor)
}
const abrirExtrato = async (produtoId: number) => {
  try {
    modalExtratoAberto.value = false // fecha antes, só por garantia
    extratoProduto.value = null // limpa dado anterior

    extratoProduto.value = await listarExtratoPorProduto(produtoId) // aguarda dado carregar

    modalExtratoAberto.value = true // abre modal só depois do dado pronto
  } catch {
    alert('Erro ao carregar extrato do produto.')
    modalExtratoAberto.value = false
  }
}

function limparFormulario() {
  movimento.value = {
    produtoId: null,
    tipo: 'ENTRADA',
    quantidade: 1,
    valor: 0
  }
  produtoSelecionado.value = null
  erro.value = ''
  sucesso.value = ''
}

async function buscarProdutos(pagina = 0) {
  paginaProduto.value = pagina
  try {
    const resposta = await listarProdutos({
      codigo: filtroProduto.codigo,
      descricao: filtroProduto.descricao,
      tipoProduto: filtroProduto.tipoProduto,
      page: paginaProduto.value,
      size: 10,
      sort: 'descricao,asc' // ← AQUI
    })

    produtos.value = resposta.content.map((p: any) => ({
      id: p.id,
      codigo: p.codigo,
      nome: p.descricao,
      tipo: p.tipoProduto,
      quantidade: p.quantidadeEstoque,
      valorFornecedor: p.valorFornecedor,
      saidas: 0
    }))
    totalPaginasProduto.value = resposta.totalPages
  } catch (e) {
    erro.value = 'Erro ao carregar produtos'
  }
}

async function buscarMovimentacoes(pagina = 0) {
  paginaMov.value = pagina
  try {
    const resposta = await listarMovimentacao({
      tipo: filtroMov.tipo,
      codigo: filtroMov.codigo, // <-- adicionado aqui
      dataInicio: filtroMov.dataInicio,
      dataFim: filtroMov.dataFim,
      page: paginaMov.value,
      size: 10
    })
    movimentacoes.value = resposta.content
    totalPaginasMov.value = resposta.totalPages
  } catch (e) {
    erro.value = 'Erro ao carregar movimentações'
  }
}
function limparFiltrosProduto() {
  filtroProduto.codigo = ''
  filtroProduto.descricao = ''
  filtroProduto.tipoProduto = ''

  filtroMov.tipo = ''
  filtroMov.codigo = ''
  filtroMov.dataInicio = ''
  filtroMov.dataFim = ''

  buscarProdutos(0)
}

function limparFiltrosMovimentacoes() {
  filtroProduto.codigo = ''
  filtroProduto.descricao = ''
  filtroProduto.tipoProduto = ''

  filtroMov.tipo = ''
  filtroMov.codigo = ''
  filtroMov.dataInicio = ''
  filtroMov.dataFim = ''

  buscarMovimentacoes(0)
}

watch(
  () => [filtroProduto.codigo, filtroProduto.descricao, filtroProduto.tipoProduto],
  () => buscarProdutos(0)
)

watch(
  () => [filtroMov.tipo, filtroMov.dataInicio, filtroMov.dataFim, filtroMov.codigo],
  () => buscarMovimentacoes(0)
)

onMounted(async () => {
  erro.value = ''
  sucesso.value = ''
  try {
    await login('admin', 'admin123') // simulação de login
    await buscarProdutos()
    await buscarMovimentacoes()
  } catch (e: any) {
    erro.value = e.response?.data?.message || 'Erro ao carregar produtos'
  }
  isLoading.value = false
})

function calcularLucro(mov: Movimentacao): string {
  if (mov.tipo === 'SAIDA' && mov.valorVenda != null) {
    const lucro = (mov.valorVenda - mov.produto.valorFornecedor) * mov.quantidade
    return formatarReais(lucro)
  }
  return '—'
}

watch(
  () => movimento.value.produtoId,
  (novoId) => {
    if (novoId == null) {
      produtoSelecionado.value = null
      movimento.value.valor = 0
    } else {
      const produto = produtos.value.find((p) => p.id === novoId)
      produtoSelecionado.value = produto || null
      if (produto) {
        movimento.value.valor =
          movimento.value.tipo === 'ENTRADA' ? produto.valorFornecedor : produto.valorVenda
      }
    }
  }
)

watch(
  () => movimento.value.tipo,
  (novoTipo) => {
    if (produtoSelecionado.value) {
      movimento.value.valor =
        novoTipo === 'ENTRADA'
          ? produtoSelecionado.value.valorFornecedor
          : produtoSelecionado.value.valorVenda
    }
  }
)

async function registrarMovimentacao() {
  erro.value = ''
  sucesso.value = ''
  const produto = produtos.value.find((p) => p.id === movimento.value.produtoId)
  if (!produto) {
    erro.value = 'Produto não encontrado.'
    return
  }

  if (movimento.value.tipo === 'ENTRADA') {
    produto.quantidade += movimento.value.quantidade
  } else {
    if (produto.quantidade < movimento.value.quantidade) {
      erro.value = `Estoque insuficiente. Saldo: ${produto.quantidade}`
      return
    }
    produto.quantidade -= movimento.value.quantidade
    produto.saidas = (produto.saidas || 0) + movimento.value.quantidade
  }

  const movimentacaoParaEnviar = {
    produto: { id: produto.id },
    tipo: movimento.value.tipo,
    valorVenda: movimento.value.tipo === 'SAIDA' ? movimento.value.valor : produto.valorFornecedor,
    dataVenda: movimento.value.tipo === 'SAIDA' ? new Date().toISOString() : null,
    quantidade: movimento.value.quantidade
  }

  try {
    const novaMovimentacao = await criarMovimentacao(movimentacaoParaEnviar)
    movimentacoes.value.push({
      id: novaMovimentacao.id,
      produto: {
        id: produto.id,
        codigo: produto.codigo,
        descricao: produto.nome,
        tipoProduto: produto.tipo,
        valorFornecedor: produto.valorFornecedor,
        quantidadeEstoque: produto.quantidade
      },
      tipo: movimento.value.tipo,
      valorVenda: movimentacaoParaEnviar.valorVenda,
      dataVenda: movimentacaoParaEnviar.dataVenda,
      quantidade: movimentacaoParaEnviar.quantidade
    })

    sucesso.value =
      movimento.value.tipo === 'SAIDA'
        ? 'Saída registrada com sucesso.'
        : 'Entrada registrada com sucesso.'
    limparFormulario()
  } catch (e) {
    erro.value = 'Erro ao registrar movimentação na API.'
  }
}

function abrirEditar(produto: Produto) {
  produtoSelecionado.value = { ...produto }
  modalEditarAberto.value = true
}

function abrirConfirmarRemocao(produto: Produto) {
  produtoSelecionado.value = produto
  modalRemocaoAberto.value = true
}

function abrirAdicionarProduto() {
  produtoParaEditar.value = null
  modalAberto.value = true
}

async function salvarProduto(produto: Produto) {
  try {
    if (!produto.id || produto.id === 0) {
      await criarProduto(produto)
    } else {
      await atualizarProduto(produto.id, produto)
    }
    modalAberto.value = false
    await buscarProdutos()
  } catch (error) {
    console.error('Erro ao salvar produto:', error)
  }
}

async function confirmarRemocao(id: number) {
  try {
    await deletarProduto(id)
    const index = produtos.value.findIndex((p) => p.id === id)
    if (index !== -1) {
      produtos.value.splice(index, 1)
      sucesso.value = 'Produto removido com sucesso.'
    }
  } catch (error) {
    console.error('Erro ao remover produto:', error)
  }
}

function aumentarQuantidade() {
  movimento.value.quantidade++
}

function diminuirQuantidade() {
  if (movimento.value.quantidade > 1) {
    movimento.value.quantidade--
  }
}
</script>
<style scoped>
* {
  box-sizing: border-box;
}

html,
body {
  margin: 0;
  padding: 0;
  height: 100%;
  background-color: #f9f9f9;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  color: #000; /* texto padrão preto */
}

h1 {
  text-align: center;
  margin-bottom: 2rem;
  color: #2c3e50;
}

form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.form-row {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
}

.main-container {
  max-width: 1500px;
  margin: 2rem auto;
  padding: 2rem;
  background-color: #f0f0f0; /* fundo cinza claro */
  border: 1px solid #ccc; /* borda cinza clara */
  border-radius: 12px; /* borda arredondada */
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05); /* leve sombra */
  color: #000;
}

.card {
  background-color: #fff;
  border-radius: 10px;
  padding: 1.5rem;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
  margin-bottom: 2rem;
  color: #000;
}

input,
select {
  width: 100%;
  padding: 0.6rem 0.75rem;
  font-size: 1rem;
  border: 1px solid #ccc;
  border-radius: 6px;
  background-color: #fff;
  color: #000;
  outline: none;
  transition:
    border-color 0.3s ease,
    box-shadow 0.3s ease;
}

input:focus,
select:focus {
  border-color: #42b983;
  box-shadow: 0 0 0 2px rgba(66, 185, 131, 0.2);
}

label {
  display: block;
  margin-bottom: 0.3rem;
  font-weight: 600;
  font-size: 0.95rem;
  color: #2c3e50;
}

table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 1rem;
  table-layout: auto; /* crescer conforme o conteúdo */
  font-size: 0.95rem;
  min-width: 600px; /* para evitar que fique muito estreita */
  color: #000;
}

th,
td {
  border-bottom: 1px solid #ddd;
  padding: 0.75rem 1rem;
  text-align: left;
  vertical-align: middle;
  white-space: nowrap; /* evita quebra estranha em colunas */
}

thead th {
  background-color: #42b983;
  color: #fff;
  font-weight: 600;
  user-select: none;
}

tbody tr:hover {
  background-color: #f5f9f7;
  cursor: default;
}

tbody td:last-child {
  white-space: normal; /* permite quebra na coluna Ações, para botões */
}

button {
  padding: 0.6rem 1.2rem;
  font-size: 1rem;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.3s ease;
  user-select: none;
}

button[type='submit'] {
  background-color: #42b983;
  color: #fff;
}

button[type='submit']:hover {
  background-color: #369b70;
}

.alert {
  color: #c0392b;
  font-weight: bold;
}

.success {
  color: #27ae60;
  font-weight: bold;
}

.btn-outline {
  background-color: #ecf0f1;
  color: #2c3e50;
  padding: 0.4rem 0.7rem;
  margin-right: 0.5rem;
  border-radius: 4px;
  border: none;
  cursor: pointer;
  font-size: 0.9rem;
  transition: background-color 0.2s ease;
}

.btn-outline:hover {
  background-color: #dcdfe1;
}

.btn-outline-red {
  background-color: #fbeaea;
  color: #c0392b;
  padding: 0.4rem 0.7rem;
  border-radius: 4px;
  font-size: 0.9rem;
  border: none;
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.btn-outline-red:hover {
  background-color: #f5c6cb;
}

.btn-outline-gren {
  background-color: #bdebbd;
  color: #649960;
  padding: 0.4rem 0.7rem;
  margin-right: 0.5rem;
  border-radius: 4px;
  font-size: 0.9rem;
  border: none;
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.btn-outline-gren:hover {
  background-color: #bdebbd;
}

.produto-detalhes {
  margin-top: 0.5rem;
  background-color: #f2f2f2;
  padding: 0.5rem;
  border-radius: 6px;
  font-size: 0.85rem;
  color: #333;
  line-height: 1.4;
}

.tipo-toggle {
  display: flex;
  gap: 0.5rem;
  margin-top: 0.4rem;
}

.tipo-toggle button {
  padding: 0.4rem 1rem;
  border: 1px solid #ccc;
  border-radius: 6px;
  background-color: #f9f9f9;
  cursor: pointer;
  font-weight: 600;
  transition:
    background-color 0.2s ease,
    border-color 0.2s ease;
  color: #2c3e50;
}

.tipo-toggle button.ativo {
  background-color: #42b983;
  color: #000;
  border-color: #42b983;
}

.tipo-toggle button:hover {
  background-color: #e0e0e0;
}

.form-row.centralizado {
  justify-content: center;
  align-items: center;
  gap: 1rem;
  display: flex;
  flex-wrap: wrap;
}

.flex-1 {
  flex: 1;
  min-width: 250px;
}

.flex-2 {
  flex: 2;
  min-width: 300px;
}

.btn-submit {
  background-color: #42b983;
  color: #fff;
  border: none;
  padding: 0.5rem 1rem;
  font-size: 0.95rem;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.btn-submit:hover {
  background-color: #369b70;
}

.btn-limpar {
  background-color: #ecf0f1;
  color: #2c3e50;
  border: none;
  padding: 0.5rem 1rem;
  font-size: 0.95rem;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.btn-limpar:hover {
  background-color: #dcdfe1;
}

.input-quantidade {
  display: flex;
  align-items: center;
  max-width: 140px;
  margin-top: 0.3rem;
  border: 1px solid #ccc;
  border-radius: 6px;
  overflow: hidden;
  background-color: #fff;
}

.input-quantidade input[type='number'] {
  border: none;
  outline: none;
  width: 60px;
  padding: 0.4rem;
  text-align: center;
  font-size: 1rem;
  -moz-appearance: textfield; /* remove setas padrão no Firefox */
}

.input-quantidade input[type='number']::-webkit-outer-spin-button,
.input-quantidade input[type='number']::-webkit-inner-spin-button {
  -webkit-appearance: none; /* remove setas padrão no Chrome */
  margin: 0;
}

.btn-quantidade {
  background-color: #42b983;
  color: #fff;
  border: none;
  width: 32px;
  height: 32px;
  font-weight: bold;
  cursor: pointer;
  user-select: none;
  transition: background-color 0.2s ease;
  display: flex;
  justify-content: center;
  align-items: center;
}

.btn-quantidade:hover {
  background-color: #369b70;
}

@media (max-width: 768px) {
  table {
    font-size: 0.85rem;
    min-width: auto;
  }
  th,
  td {
    padding: 0.5rem 0.75rem;
  }
  .btn-outline,
  .btn-outline-gren,
  .btn-outline-red {
    font-size: 0.75rem;
    padding: 0.25rem 0.5rem;
  }
  .flex-1,
  .flex-2 {
    min-width: 100%;
    flex: 1 1 100%;
  }
  .form-row {
    flex-direction: column;
  }
}

.form-row.centralizado {
  display: flex;
  justify-content: center;
  align-items: flex-start; /* alinhamento topo */
  gap: 1rem;
  flex-wrap: nowrap;
}

.produto-com-detalhes {
  display: flex;
  flex-direction: column;
  min-width: 0; /* importante para que o flex-basis funcione corretamente */
  flex: 1 1 50%; /* ocupa 50% do espaço e pode encolher */
}

.tipo-toggle-wrapper {
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  min-width: 0; /* para que flex-basis funcione */
  flex: 1 1 50%; /* ocupa 50% do espaço */
  max-width: 250px; /* opcional, para limitar o toggle */
}
.entrada {
  background-color: #d0f0fd; /* azul bem suave */
  color: #000000;
  font-weight: bold;
  padding: 4px 8px;
  border-radius: 3px;
  text-align: center;
}

.saida {
  background-color: #a3e091; /* vermelho bem suave */
  color: #000000;
  font-weight: bold;
  padding: 4px 8px;
  border-radius: 3px;
  text-align: center;
}

.exclusao {
  background-color: #f8d7da; /* vermelho claro suave */
  color: #721c24; /* vermelho escuro para texto */
  font-weight: bold;
  padding: 4px 8px;
  border-radius: 3px;
  text-align: center;
}

td strong {
  font-weight: 700;
}

table th,
table td {
  text-align: center;
  vertical-align: middle;
}

.filtros-produtos {
  display: flex;
  gap: 1rem;
  margin-bottom: 1rem;
}
.filtros-produtos input,
.filtros-produtos select {
  width: 350px;
  max-width: 100%;
}

.filtros-movimentacoes {
  display: flex;
  gap: 1rem;
  margin-bottom: 1rem;
}

.filtros-movimentacoes input,
.filtros-movimentacoes select {
  width: 300px;
  max-width: 100%;
}

.pagination {
  margin-top: 1rem;
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 1rem;
}

.pagination button {
  border: 1.5px solid #28a745; /* verde limpo */
  background-color: white;
  color: #212529; /* cinza escuro quase preto */
  padding: 0.4rem 0.9rem;
  border-radius: 4px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.25s ease;
}

.pagination button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  border-color: #ced4da;
  color: #6c757d;
  background-color: #f8f9fa;
}

.pagination button:not(:disabled):hover,
.pagination button:not(:disabled):focus {
  background-color: #28a745;
  color: white;
  border-color: #28a745;
}

.pagination button:not(:disabled):active {
  background-color: #218838;
  border-color: #1e7e34;
  color: white;
}
</style>
