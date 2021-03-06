��
l��F� j�P.�M�.�}q (X   protocol_versionqM�X   little_endianq�X
   type_sizesq}q(X   shortqKX   intqKX   longqKuu.�(X   moduleq clm
NameGenerator
qX7   /mnt/c/Users/kdcha/Documents/Winter19/NLP/Project/lm.pyqX�  class NameGenerator(nn.Module):
    def __init__(self, input_vocab_size, n_embedding_dims, n_hidden_dims, n_lstm_layers, output_vocab_size):
        """
        Initialize our name generator, following the equations laid out in the assignment. In other words,
        we'll need an Embedding layer, an LSTM layer, a Linear layer, and LogSoftmax layer. 
        
        Note: Remember to set batch_first=True when initializing your LSTM layer!

        Also note: When you build your LogSoftmax layer, pay attention to the dimension that you're 
        telling it to run over!
        """
        super(NameGenerator, self).__init__()
        self.lstm_dims = n_hidden_dims
        self.lstm_layers = n_lstm_layers

        self.input_lookup = nn.Embedding(num_embeddings=input_vocab_size, embedding_dim=n_embedding_dims)
        self.lstm = nn.LSTM(input_size=n_embedding_dims, hidden_size=n_hidden_dims, num_layers=n_lstm_layers, batch_first=True, bidirectional=False)
        self.output = nn.Linear(in_features=n_hidden_dims, out_features=output_vocab_size)
        self.softmax = nn.LogSoftmax(dim=2)


    def forward(self, history_tensor, prev_hidden_state):
        """
        Given a history, and a previous timepoint's hidden state, predict the next character. 
        
        Note: Make sure to return the LSTM hidden state, so that we can use this for
        sampling/generation in a one-character-at-a-time pattern, as in Goldberg 9.5!
        """     
        out = self.input_lookup(history_tensor)

        out, hidden = self.lstm(out)
        out = self.output(out)
        out = self.softmax(out)
        #last_out = out[:,-1,:].squeeze() 
        return out, hidden
        
    def init_hidden(self):
        """
        Generate a blank initial history value, for use when we start predicting over a fresh sequence.
        """
        h_0 = torch.randn(self.lstm_layers, 1, self.lstm_dims)
        c_0 = torch.randn(self.lstm_layers, 1, self.lstm_dims)
        return(h_0,c_0)
qtqQ)�q}q(X   _backendqctorch.nn.backends.thnn
_get_thnn_function_backend
q)Rq	X   _parametersq
ccollections
OrderedDict
q)RqX   _buffersqh)RqX   _backward_hooksqh)RqX   _forward_hooksqh)RqX   _forward_pre_hooksqh)RqX   _modulesqh)Rq(X   input_lookupq(h ctorch.nn.modules.sparse
Embedding
qXM   /home/kchalk/anaconda3/lib/python3.6/site-packages/torch/nn/modules/sparse.pyqX?  class Embedding(Module):
    r"""A simple lookup table that stores embeddings of a fixed dictionary and size.

    This module is often used to store word embeddings and retrieve them using indices.
    The input to the module is a list of indices, and the output is the corresponding
    word embeddings.

    Args:
        num_embeddings (int): size of the dictionary of embeddings
        embedding_dim (int): the size of each embedding vector
        padding_idx (int, optional): If given, pads the output with the embedding vector at :attr:`padding_idx`
                                         (initialized to zeros) whenever it encounters the index.
        max_norm (float, optional): If given, will renormalize the embedding vectors to have a norm lesser than
                                    this before extracting.
        norm_type (float, optional): The p of the p-norm to compute for the max_norm option. Default ``2``.
        scale_grad_by_freq (boolean, optional): if given, this will scale gradients by the inverse of frequency of
                                                the words in the mini-batch. Default ``False``.
        sparse (bool, optional): if ``True``, gradient w.r.t. :attr:`weight` matrix will be a sparse tensor.
                                 See Notes for more details regarding sparse gradients.

    Attributes:
        weight (Tensor): the learnable weights of the module of shape (num_embeddings, embedding_dim)

    Shape:

        - Input: LongTensor of arbitrary shape containing the indices to extract
        - Output: `(*, embedding_dim)`, where `*` is the input shape

    .. note::
        Keep in mind that only a limited number of optimizers support
        sparse gradients: currently it's :class:`optim.SGD` (`CUDA` and `CPU`),
        :class:`optim.SparseAdam` (`CUDA` and `CPU`) and :class:`optim.Adagrad` (`CPU`)

    .. note::
        With :attr:`padding_idx` set, the embedding vector at
        :attr:`padding_idx` is initialized to all zeros. However, note that this
        vector can be modified afterwards, e.g., using a customized
        initialization method, and thus changing the vector used to pad the
        output. The gradient for this vector from :class:`~torch.nn.Embedding`
        is always zero.

    Examples::

        >>> # an Embedding module containing 10 tensors of size 3
        >>> embedding = nn.Embedding(10, 3)
        >>> # a batch of 2 samples of 4 indices each
        >>> input = torch.LongTensor([[1,2,4,5],[4,3,2,9]])
        >>> embedding(input)
        tensor([[[-0.0251, -1.6902,  0.7172],
                 [-0.6431,  0.0748,  0.6969],
                 [ 1.4970,  1.3448, -0.9685],
                 [-0.3677, -2.7265, -0.1685]],

                [[ 1.4970,  1.3448, -0.9685],
                 [ 0.4362, -0.4004,  0.9400],
                 [-0.6431,  0.0748,  0.6969],
                 [ 0.9124, -2.3616,  1.1151]]])


        >>> # example with padding_idx
        >>> embedding = nn.Embedding(10, 3, padding_idx=0)
        >>> input = torch.LongTensor([[0,2,0,5]])
        >>> embedding(input)
        tensor([[[ 0.0000,  0.0000,  0.0000],
                 [ 0.1535, -2.0309,  0.9315],
                 [ 0.0000,  0.0000,  0.0000],
                 [-0.1655,  0.9897,  0.0635]]])
    """

    def __init__(self, num_embeddings, embedding_dim, padding_idx=None,
                 max_norm=None, norm_type=2, scale_grad_by_freq=False,
                 sparse=False, _weight=None):
        super(Embedding, self).__init__()
        self.num_embeddings = num_embeddings
        self.embedding_dim = embedding_dim
        if padding_idx is not None:
            if padding_idx > 0:
                assert padding_idx < self.num_embeddings, 'Padding_idx must be within num_embeddings'
            elif padding_idx < 0:
                assert padding_idx >= -self.num_embeddings, 'Padding_idx must be within num_embeddings'
                padding_idx = self.num_embeddings + padding_idx
        self.padding_idx = padding_idx
        self.max_norm = max_norm
        self.norm_type = norm_type
        self.scale_grad_by_freq = scale_grad_by_freq
        if _weight is None:
            self.weight = Parameter(torch.Tensor(num_embeddings, embedding_dim))
            self.reset_parameters()
        else:
            assert list(_weight.shape) == [num_embeddings, embedding_dim], \
                'Shape of weight does not match num_embeddings and embedding_dim'
            self.weight = Parameter(_weight)
        self.sparse = sparse

    def reset_parameters(self):
        self.weight.data.normal_(0, 1)
        if self.padding_idx is not None:
            self.weight.data[self.padding_idx].fill_(0)

    def forward(self, input):
        return F.embedding(
            input, self.weight, self.padding_idx, self.max_norm,
            self.norm_type, self.scale_grad_by_freq, self.sparse)

    def extra_repr(self):
        s = '{num_embeddings}, {embedding_dim}'
        if self.padding_idx is not None:
            s += ', padding_idx={padding_idx}'
        if self.max_norm is not None:
            s += ', max_norm={max_norm}'
        if self.norm_type != 2:
            s += ', norm_type={norm_type}'
        if self.scale_grad_by_freq is not False:
            s += ', scale_grad_by_freq={scale_grad_by_freq}'
        if self.sparse is not False:
            s += ', sparse=True'
        return s.format(**self.__dict__)

    @classmethod
    def from_pretrained(cls, embeddings, freeze=True, sparse=False):
        r"""Creates Embedding instance from given 2-dimensional FloatTensor.

        Args:
            embeddings (Tensor): FloatTensor containing weights for the Embedding.
                First dimension is being passed to Embedding as 'num_embeddings', second as 'embedding_dim'.
            freeze (boolean, optional): If ``True``, the tensor does not get updated in the learning process.
                Equivalent to ``embedding.weight.requires_grad = False``. Default: ``True``
            sparse (bool, optional): if ``True``, gradient w.r.t. weight matrix will be a sparse tensor.
                See Notes for more details regarding sparse gradients.

        Examples::

            >>> # FloatTensor containing pretrained weights
            >>> weight = torch.FloatTensor([[1, 2.3, 3], [4, 5.1, 6.3]])
            >>> embedding = nn.Embedding.from_pretrained(weight)
            >>> # Get embeddings for index 1
            >>> input = torch.LongTensor([1])
            >>> embedding(input)
            tensor([[ 4.0000,  5.1000,  6.3000]])
        """
        assert embeddings.dim() == 2, \
            'Embeddings parameter is expected to be 2-dimensional'
        rows, cols = embeddings.shape
        embedding = cls(
            num_embeddings=rows,
            embedding_dim=cols,
            _weight=embeddings,
            sparse=sparse,
        )
        embedding.weight.requires_grad = not freeze
        return embedding
qtqQ)�q}q(hh	h
h)RqX   weightqctorch.nn.parameter
Parameter
q ctorch._utils
_rebuild_tensor_v2
q!((X   storageq"ctorch
FloatStorage
q#X   140736700540016q$X   cpuq%M�
Ntq&QK KUK �q'K K�q(�Ntq)Rq*��q+Rq,shh)Rq-hh)Rq.hh)Rq/hh)Rq0hh)Rq1X   trainingq2�X   num_embeddingsq3KUX   embedding_dimq4K X   padding_idxq5NX   max_normq6NX	   norm_typeq7KX   scale_grad_by_freqq8�X   sparseq9�ubX   lstmq:(h ctorch.nn.modules.rnn
LSTM
q;XJ   /home/kchalk/anaconda3/lib/python3.6/site-packages/torch/nn/modules/rnn.pyq<X0  class LSTM(RNNBase):
    r"""Applies a multi-layer long short-term memory (LSTM) RNN to an input
    sequence.


    For each element in the input sequence, each layer computes the following
    function:

    .. math::

            \begin{array}{ll}
            i_t = \sigma(W_{ii} x_t + b_{ii} + W_{hi} h_{(t-1)} + b_{hi}) \\
            f_t = \sigma(W_{if} x_t + b_{if} + W_{hf} h_{(t-1)} + b_{hf}) \\
            g_t = \tanh(W_{ig} x_t + b_{ig} + W_{hg} h_{(t-1)} + b_{hg}) \\
            o_t = \sigma(W_{io} x_t + b_{io} + W_{ho} h_{(t-1)} + b_{ho}) \\
            c_t = f_t c_{(t-1)} + i_t g_t \\
            h_t = o_t \tanh(c_t)
            \end{array}

    where :math:`h_t` is the hidden state at time `t`, :math:`c_t` is the cell
    state at time `t`, :math:`x_t` is the input at time `t`, :math:`h_{(t-1)}`
    is the hidden state of the previous layer at time `t-1` or the initial hidden
    state at time `0`, and :math:`i_t`, :math:`f_t`, :math:`g_t`,
    :math:`o_t` are the input, forget, cell, and output gates, respectively.
    :math:`\sigma` is the sigmoid function.

    Args:
        input_size: The number of expected features in the input `x`
        hidden_size: The number of features in the hidden state `h`
        num_layers: Number of recurrent layers. E.g., setting ``num_layers=2``
            would mean stacking two LSTMs together to form a `stacked LSTM`,
            with the second LSTM taking in outputs of the first LSTM and
            computing the final results. Default: 1
        bias: If ``False``, then the layer does not use bias weights `b_ih` and `b_hh`.
            Default: ``True``
        batch_first: If ``True``, then the input and output tensors are provided
            as (batch, seq, feature). Default: ``False``
        dropout: If non-zero, introduces a `Dropout` layer on the outputs of each
            LSTM layer except the last layer, with dropout probability equal to
            :attr:`dropout`. Default: 0
        bidirectional: If ``True``, becomes a bidirectional LSTM. Default: ``False``

    Inputs: input, (h_0, c_0)
        - **input** of shape `(seq_len, batch, input_size)`: tensor containing the features
          of the input sequence.
          The input can also be a packed variable length sequence.
          See :func:`torch.nn.utils.rnn.pack_padded_sequence` or
          :func:`torch.nn.utils.rnn.pack_sequence` for details.
        - **h_0** of shape `(num_layers * num_directions, batch, hidden_size)`: tensor
          containing the initial hidden state for each element in the batch.
        - **c_0** of shape `(num_layers * num_directions, batch, hidden_size)`: tensor
          containing the initial cell state for each element in the batch.

          If `(h_0, c_0)` is not provided, both **h_0** and **c_0** default to zero.


    Outputs: output, (h_n, c_n)
        - **output** of shape `(seq_len, batch, num_directions * hidden_size)`: tensor
          containing the output features `(h_t)` from the last layer of the LSTM,
          for each t. If a :class:`torch.nn.utils.rnn.PackedSequence` has been
          given as the input, the output will also be a packed sequence.

          For the unpacked case, the directions can be separated
          using ``output.view(seq_len, batch, num_directions, hidden_size)``,
          with forward and backward being direction `0` and `1` respectively.
          Similarly, the directions can be separated in the packed case.
        - **h_n** of shape `(num_layers * num_directions, batch, hidden_size)`: tensor
          containing the hidden state for `t = seq_len`.

          Like *output*, the layers can be separated using
          ``h_n.view(num_layers, num_directions, batch, hidden_size)`` and similarly for *c_n*.
        - **c_n** (num_layers * num_directions, batch, hidden_size): tensor
          containing the cell state for `t = seq_len`

    Attributes:
        weight_ih_l[k] : the learnable input-hidden weights of the :math:`\text{k}^{th}` layer
            `(W_ii|W_if|W_ig|W_io)`, of shape `(4*hidden_size x input_size)`
        weight_hh_l[k] : the learnable hidden-hidden weights of the :math:`\text{k}^{th}` layer
            `(W_hi|W_hf|W_hg|W_ho)`, of shape `(4*hidden_size x hidden_size)`
        bias_ih_l[k] : the learnable input-hidden bias of the :math:`\text{k}^{th}` layer
            `(b_ii|b_if|b_ig|b_io)`, of shape `(4*hidden_size)`
        bias_hh_l[k] : the learnable hidden-hidden bias of the :math:`\text{k}^{th}` layer
            `(b_hi|b_hf|b_hg|b_ho)`, of shape `(4*hidden_size)`

    Examples::

        >>> rnn = nn.LSTM(10, 20, 2)
        >>> input = torch.randn(5, 3, 10)
        >>> h0 = torch.randn(2, 3, 20)
        >>> c0 = torch.randn(2, 3, 20)
        >>> output, (hn, cn) = rnn(input, (h0, c0))
    """

    def __init__(self, *args, **kwargs):
        super(LSTM, self).__init__('LSTM', *args, **kwargs)
q=tq>Q)�q?}q@(hh	h
h)RqA(X   weight_ih_l0qBh h!((h"h#X   140736699476192qCh%M 
NtqDQK KPK �qEK K�qF�NtqGRqH��qIRqJX   weight_hh_l0qKh h!((h"h#X   140736699362512qLh%M@NtqMQK KPK�qNKK�qO�NtqPRqQ��qRRqSX
   bias_ih_l0qTh h!((h"h#X   140736700026768qUh%KPNtqVQK KP�qWK�qX�NtqYRqZ��q[Rq\X
   bias_hh_l0q]h h!((h"h#X   140736699501008q^h%KPNtq_QK KP�q`K�qa�NtqbRqc��qdRqeuhh)Rqfhh)Rqghh)Rqhhh)Rqihh)Rqjh2�X   modeqkX   LSTMqlX
   input_sizeqmK X   hidden_sizeqnKX
   num_layersqoKX   biasqp�X   batch_firstqq�X   dropoutqrK X   dropout_stateqs}qtX   bidirectionalqu�X   _all_weightsqv]qw]qx(hBhKhTh]eaX
   _data_ptrsqy]qzubX   outputq{(h ctorch.nn.modules.linear
Linear
q|XM   /home/kchalk/anaconda3/lib/python3.6/site-packages/torch/nn/modules/linear.pyq}X%  class Linear(Module):
    r"""Applies a linear transformation to the incoming data: :math:`y = xA^T + b`

    Args:
        in_features: size of each input sample
        out_features: size of each output sample
        bias: If set to False, the layer will not learn an additive bias.
            Default: ``True``

    Shape:
        - Input: :math:`(N, *, in\_features)` where :math:`*` means any number of
          additional dimensions
        - Output: :math:`(N, *, out\_features)` where all but the last dimension
          are the same shape as the input.

    Attributes:
        weight: the learnable weights of the module of shape
            `(out_features x in_features)`
        bias:   the learnable bias of the module of shape `(out_features)`

    Examples::

        >>> m = nn.Linear(20, 30)
        >>> input = torch.randn(128, 20)
        >>> output = m(input)
        >>> print(output.size())
    """

    def __init__(self, in_features, out_features, bias=True):
        super(Linear, self).__init__()
        self.in_features = in_features
        self.out_features = out_features
        self.weight = Parameter(torch.Tensor(out_features, in_features))
        if bias:
            self.bias = Parameter(torch.Tensor(out_features))
        else:
            self.register_parameter('bias', None)
        self.reset_parameters()

    def reset_parameters(self):
        stdv = 1. / math.sqrt(self.weight.size(1))
        self.weight.data.uniform_(-stdv, stdv)
        if self.bias is not None:
            self.bias.data.uniform_(-stdv, stdv)

    def forward(self, input):
        return F.linear(input, self.weight, self.bias)

    def extra_repr(self):
        return 'in_features={}, out_features={}, bias={}'.format(
            self.in_features, self.out_features, self.bias is not None
        )
q~tqQ)�q�}q�(hh	h
h)Rq�(hh h!((h"h#X   140736699447424q�h%M�Ntq�QK KUK�q�KK�q��Ntq�Rq���q�Rq�hph h!((h"h#X   140736698537040q�h%KUNtq�QK KU�q�K�q��Ntq�Rq���q�Rq�uhh)Rq�hh)Rq�hh)Rq�hh)Rq�hh)Rq�h2�X   in_featuresq�KX   out_featuresq�KUubX   softmaxq�(h ctorch.nn.modules.activation
LogSoftmax
q�XQ   /home/kchalk/anaconda3/lib/python3.6/site-packages/torch/nn/modules/activation.pyq�X  class LogSoftmax(Module):
    r"""Applies the `Log(Softmax(x))` function to an n-dimensional input Tensor.
    The LogSoftmax formulation can be simplified as

    :math:`\text{LogSoftmax}(x_{i}) = \log\left(\frac{\exp(x_i) }{ \sum_j \exp(x_j)} \right)`

    Shape:
        - Input: any shape
        - Output: same as input

    Arguments:
        dim (int): A dimension along which Softmax will be computed (so every slice
            along dim will sum to 1).

    Returns:
        a Tensor of the same dimension and shape as the input with
        values in the range [-inf, 0)

    Examples::

        >>> m = nn.LogSoftmax()
        >>> input = torch.randn(2, 3)
        >>> output = m(input)
    """

    def __init__(self, dim=None):
        super(LogSoftmax, self).__init__()
        self.dim = dim

    def __setstate__(self, state):
        self.__dict__.update(state)
        if not hasattr(self, 'dim'):
            self.dim = None

    def forward(self, input):
        return F.log_softmax(input, self.dim, _stacklevel=5)
q�tq�Q)�q�}q�(hh	h
h)Rq�hh)Rq�hh)Rq�hh)Rq�hh)Rq�hh)Rq�h2�X   dimq�Kubuh2�X	   lstm_dimsq�KX   lstm_layersq�Kub.�]q (X   140736698537040qX   140736699362512qX   140736699447424qX   140736699476192qX   140736699501008qX   140736700026768qX   140736700540016qe.U       )g0��ӿ�b����Ѽ��P�!��E���k���a���:3>
�������n������ݾ�]2�T_���^?�
��N-?�$�[����᜾�I���Y���e+� ϖ��P��$%��]��?ʃ>�,I�G^ѾNe��Ԡ�n���!�����/���߿BI���B�r�%��ᄿ��\���^�`�h��pĽ�|H��#h�v)�'z׿GI+���V��_�{~��#�����D����b�M+>�&��$k>��{?4w���7��$�>VQۿKP�*i������>�l����;����9��r0J�����v�Āv�����X��55�@      #Kr?N�d��_$?Ck�?(v>��>f��?�yν��=;3���9�����d`(>$FZ>1rv��<����?�u��F�=��>b�?����ü�?��@��=�@?�E�=�u�b2r>V�b?�VI��v�>B���a�3�J����0�0��>���<��=_�U?8��>UWS�;>>Ci$?��ǽ�Q�=<B�?�F?�fU�!˽g��[����J]?G�	@@3��?�6���?�i?))���a��܊�T�?2���j����?Us>7w��+�I?T�@����H���>�ث�Ӕ��Ѻ�?rv_?�J����>�2����?SZ��-@�A@ܚ;>�'�>��@�7�?)�?�t?��6?��?�S�>�2�?�k�OV�?�G��}��(6?��?ᗾ�}2?���?�ݮ�~��>	h?c�?�p>?��?�oƾ�z�>�̾��n>X�?+ɾHa @J?�J�=���B`'?��5�W���ܾ�RT?�5��^�-n�?}��?d�J��`�����?�"?-	Y�9�S��� �o��?E�>ŌҾb ?�d����?��?�o����{�?_�-�W���?{lؾ2�?����-/m��)@ֵ����f�X`%��)�� �?���;��=81?Aq?+2�>�+���<��?�ʜ=O(��;��,���x>2�>�����j��3'�W��>�p��K˾J�>&�X><��>�4?\Ҭ?�L�=/��q��?��?�	x>v��?�L廦'L���C�;Q�&����
?:�4?nѦ���d��>?S�~?��ꑿ�G?Z�|<��?������?�$�?@r����=ӄ>%��Wa�=`��H\�+��?<o?��:���쾸���Z�= 4��ㅽ?��>*m�>-�}�:>}�>>棿���?��J?,k9�%�?�ݿ�A׿�$�>��˿S4h?�5?]�_>�@��`@�ϓ?�܆?~�R����?�s@�3c?mo�=7���d-?�����X	�5�M�ܥ��.@3y�?$��8�=k�>�i�?��j��Y�3��>����O�>Q*:��_W�˷����>�z�����=��	@p��>Z����e�=eQ	>�Ή��I�-�ֽɾ5�sh�?���q[=}6�}v����5?����a�̃=^���Ҏ?Fq?��?�V�Oޖ�&�����ÿ�>8��D����]?��-�r�D�o���55�>"��=NS��y_���>�iǾhݦ��(�>q?���>�El>tLt����H�G?T)0?I��>H�B?�ԭ?%tm?�w�=*K�?<?���>�	�>�����k�>��ͽ��_�O�~�m���4>k}۾�F���A>�1�Ո�=����v?֜�?�~D?P?�2�>?�M*?��U���>p��_H���O?B���[?��E?��>�m�^��=7Ԓ>�፿>�<뾻�/�\�M?6��?���>�|�="8?�>�?6�S>vð>�4 ����>�!�?t��>g�)?^7G>�w�?u��<�7�?������#���Q?DiD?�N�?G?�1�l�ۿ5n?��*����>,ջ���,	2���$?7�>4m�>y@c>�Ѝ?���?ٔ?�u4�_2?�;�?۪b?k���$�7?�B��w�=ܒp��J?�w�� �g����?"�������>�7�#M�?��2>�Q�?{+?��>�;�>ߢ��ƾ�L?'�
��ױ�?ſ�=4G0�[���@�,��d-]??�?��c>'�����ZӋ?ȸ��<�=���9>�/?r��? �C?�A!?�x��]���^��>þ�E�x8��1f�W�����0=.�]�@�u��w@���=�b�����>;��;x��>�	��Dm@���?����>��� �>���SW?\g�����{�?�B?��	��ӿl3Ҿ����¾@�1�>d�?��>��P��!L�+zm�2�����e��� ���b�@ʘ�����f�?~�>�����谿�r�?OzB?��>>�?�*�>Z�2�a^�CE?�؛��L>���>]�=�U�'?���?]M>X@}>,KM>-q=>�������� �?��>֌�?c����<U��?6*?��?j~	��6>:˩������O���j���E�	 ?��E=qS5@U��?w/�r�Խ\j2��-������|�?�JT�Q}վ�Se��L1>bji?�?#�1>Z;����^�?���?�w>>>���j�>�Z��ђ�?���?�bT���U�������?5Hx��X��"m�O�7��W@��p=N��I�˿�f�?:���U�{^����ξ�п��@�8��86%@_(Ծ��>���k�ȿ����ET=q.a�����!�>�R�=�x��]ిV>���2?7�?�\�U�?y1�"'����X��o�����./�?A|��W�?|y��U�=��t��(��%���?A�+?�9�}M ?u�N>��q?$�4���=?>`|?D0�?�ֽ'b���ڿ?uL��)2�?-��:~��Z���C�?�h�>Q=��>59�-�]?OlR?������o?yB>>��>hp���?���?B��>
,,?P�R?��>q�>\��P�'@��>P�O�_�����U�Z�J>��@��,'��N�\rʾ�j����[?FN��+���ү��g�U/�>���>/N@4�H?v�E@"�?t0u����?�۾~�>+�>=ר�*�>֖?��_���s�?۲�>��@c��V�?�8����?����-\+��=m�W�����E���ſl�R?�T@�R�?Q�?�*�}*@FpU�x?�O>�OT�҄?˂�?�ſ�gh?�8�?8�����>?�[������N�>NՌ?z�?�c���p�9��=��<�����>�za?EQ?e�����>�X�?L��?m#^>�����Ƴ=���?tԬ>|z������S�����K��>鿅k�?�!\>�Ѯ��k�g�.@�8�?�X�D?N�?[l�����Z�޿��ڿ��z�j�?�K���}{<�t�?ʱ@���>���?K2�?�1�?#'�?�VL?��%���V����)���W��c�?�>��P?��2?�J�?�)[?�q��ڣ�?�V���?2�*��L����~�.�n�
}�=f�c���?�3ۿ-a�=��"?���?��������U���K��W�?�z��Y���(?K	O>\7u�L.��w����p�9�?��?�a,�W���n�?��9�!���%>(�>-��==]�?��ɿ�h�M�>"���L?��r����?���=��þ�i彁l�=eR��U��>���I���Mb?�x_���ǿ� ?����4=�rP�y�>%����?�s�>��a�wf��_ӿ�s5>A�V�c�C?�~�>�%�>�b
���߾1�>#!�;ȯ?K3?�??Lu�>"�)�@����ym��1n<Oi�?9"���p�L�����>!
\�ez6?_��?��#�hR���}��&ÿ�b?K�#>D܄�5��gb>�_�=E�:?kf�?�<��]��s��?�W���R>N���vہ��Z9�)�@Mo-?�˫>_��l3����?�?<?t= @�����K�>ݭu?<tV���˾Y���ۿE&�?�|?4|����>t#�?4�d������|��3(?����4iǾ�9>�E��	��\��� h>���?4%�r@"?l�~=��?�Hݾ��0�.�έc?�ۯ?��>�	�=��V?��?�	��?֊���/G��Е>@r�>)��?������?gL��Y�=)G�>&��aP�>d3+=KD?mv�?w����_�^F @d����?u�>�Q`��6^��?Jo>��?\�^���-��4?X��>c�|>u�8?��>�&~�C�����n�A?���?.G�>9x�?>������>~N?��>��>῿��8<��>@�_?��̾���������N�?@B����I�l�g������?���=,j�>H��lt���|��s�,?\�ؾAa���'?DT�?��S>�꼾��	�T��>s鎾'�M���m�2�1>�q,?(�þd�?K�=���?��>y�ǿu�>FԾj
�b]���W�����<a�;��22@��>�୿C����[�G�j?��>�p̾�����w�s���␂>�D�>��V<�ޜ?�.��x���׾㸕?-G����*����ؿl3�?��	=�]���=�>��7?װ%���=�6Z���;��>"�>� ����?�*?�Z���8>����>?���:/Z���<Te��������s�ѿ�*���K?�"X�]����.���=A?�z?F6׿ ؾħ����ھ/��=(�@��ſ#�7>�-@*�?�l�jE��N��<��������g>F��iݿ[��>f� =H�/?P�G�qdt��=�>@'��p�����?�X?��h�x\!@�Hz� e? �Ǿ">�:��?lu?���?pP??�-��5?^��>~��8R�3%���(�?Si�>�fB=A(q��/���;澀�ɿ��>���n:=?�&�?,��?|�F?CHu?Y�??�����&4����)���"�O_>I>?i4)��0��	>�Dؽo$�?�����ȡ��1#?8ux�w�������3���i@�.���	�;����~���eI@K���	��|���n���!>(kR@Se�f?dh�?0S��췾�4�vqo?7b�=	�>L�U��ŽNr���t�>���<�$���(>��a�]��qH$���h?��7?�c?�}�2�j�{&޿�����ֿ���?j����`?w���`�K�>Ӽ;?�@���=ߜ>ؐ�?�	b��uX�J1�?lW>v��>�5<�/ `>Y��4�����j?���C�2?B��S�>�9�-�1�"��NM�U�?"��?�v�?�q�>ߒ��>S�t43�/���R;�>yʔ?��d?#�>`,?]�E?M

?�EW�2%?�;?�<�>sP^�9��=�7o�������>ek�O�<?N�H?ܔ�����>�����
��E��2;�rڊ?���?���>�{&�F���
�(�����>GܿT��bu?}�a��]_�a$�<��M�a������M\?�Y"�;�B�>L���w�C>;�>�K?��@C¤��Ѿ(�?9-?Y�ݾ7�>d�r��>-�R����A����[��;�{��<���oMY�J�2?�.�����<),���Y���7q�~�>��?�%ʿ�%���?;�~�bY��V�>3z?O�r�M�^�<��Q�>�9�=�f?n�?�`��o>=�_�����yW�>i5f?���3�.��޿0Zx�/}��B�>�9>y�<ʰ&<f��>��½��p?7"&� �i��+̾�9龂�}�>F9?߃K>�>���>]~O=�f����#��+G>K����$m?��>��̿�4�>��>�1��M�o��k�s>�O]=��R����Υn�׺q>�kͿ5$H��#��j?S�gH ��7>���?�|��\��̦?�s�y����qJ��K�(�>?X4�!�}?��?z ��γ?D	d�R3�D�>��%>v\��)F?��>�-@8�$�-��?�vi���� i;���7?��]���~���T>??���>���?�0�r�?�ڐ��P��&Bq?U�ܾa�@�S�� DD�+��>~Y�/�v�qۓ�73�?��>]B.�s�>^`�$��?�W����}���^>��@���=�����?@dYU>3�
?�k�⻝�6�Կ��ͿW={��d����?Z̆�-F�>JF@@�?�X�x���҈��G �`$�?��8��d[�5=@l�m?�r?�7�0�>����칍>�:�?�z�JJ���N���3�s-�~ߗ=���>�v?�
>���[�I��< \?t��?mv�>�c����?�
��@\�������˿m;�>�{�0rQ��<(?m��;d����U=��j?ŵ����?��4?_	�>7$�/l�?����.|�>*�g?[	X��>?Q�>�`�?&�>.��=/��?��L��(�>���=g��>�%��"G=8���<<?�{y����>؁�>*�q��^?I��;=H��cn�.qN>� m�5�<?^V?r����?�!0?�L�=fp��V>?�^	�Hx?�<>�T?y��up�?u��?�?�%���D�a��eq4�$��>�޳?OؾN�H��|}?�䷿"�o��?�1���ؾb�?*?��{?���ض�X2?{����d���ԾiN�?��Q���)��Ј>)�}�����>Z"W��s"���Ի�N��>�E @�>�G��U~��I�@��?ڣ2?S-����?���u�6�Ɉ2>�\���*.?��0���T�� ��      �1�>�����4t�̒��H�@�!����?T+��4$?���@��A��n�`q?�o<�%`P���@H3�>���>��@��%@�d�*�w�U�N��?�3*�>�W��>��?QѰ>��?���>��̿���쨱>&����#��#��?$0�?
�>���?�8�?�o�S����{�������@Bm���	�?�q�~Z� �#A��������?�NG����=�@F���?���@��?���!6��H��a�2��U������.�>j4�Ea���@f��v;�'0�%"?��b>�B9@�o?ہO?�@��]�ҾG῀�=��N��Ͼ1�������xi�2���){�@�篿�q��!䄿�ᾈ��?��?�I�>3[?�c�?�iý�[�=�85�,��g�#��H�>���u҃?�F�%�����@d���=V�A�F��-n�����Z@��?l��?�u�?�,����?%���u���w��8mf@:����)�?#�������@������J	?�!�P��]��@��E?�u�>�b�@&&�?��3?�*1��X���}]�d��>���7R?��=�DE뿰Ɯ@�������������p>H�G�>�T@J�?�I�>�@A�߽@�
?%e����{m��M�=��⿯�E�|�4�ͫԿp@�@ƿ��ٮ�ϳ��p6>�;�?1@@�n�>N?��?w�`��~c?]�:�j�����A�?��"�_�?��{����=r�@�Ŀ!�8�Y9U��_>�6C��mH@	.�?�s2?/л?׳��B?m���h��U���p'�?�!��o�?�Q�����@����~OT�(�>]�#���:@�?��>޳n@�6�?� P>;()�����þ�6�ǀ��mA���W������!@�e��Ϗ?6�I��l��R��IGf��?&��?�v�?4vm�+�b�@����Ԗ�����>zP���J����=F߿7�@�ҿ=��es����T�7?�Z�?����XB?�Y??2���)>�>�r�����6�?bA;��5?+��	����@<=����?�y³�qM��i�v���y@'j{?��>��@%WL���>���;�
��v���1�@���`І?s��o�L��c�@y�M���Ͽ�2�?�%�']
>�1F@�'�=�O�>1[�@�x@��>c�n��
���bV�b2?�����>�s��Y���Ȕ@郿�&侗|ݾ�&8�����
?r@��?�4b?��@�Hپ��=�ť*�f���V敿�?����۷��M�������@����s��.�X����ϋ�?B�@	j�?)�!?vW�?�u��>R�Q�zU�Q�m�
��?�N����?v��VݿsUp@ Pƿ�b��V-��B5�� ����a@���?��>�� @��.��2M?.7����C��ٿl�?�J��y�~?���^����5�@mi:�u�F��_n��A޿�@߿M�@Q��>�p_=�p�@m
��>���6�g+�V<̿`�Y?<���tj���{���ʹ��J�@@j��u	��#e�VV�D�;?��6@c <>֝>m�?�<V����>>����mj��ʏ@�)����K?�7��BK�X�@�J��h���������"��U�@��?Z�>z0@�0�>'p]>AM��$�v�������@rϊ���?����͉b����@P�����{ݗ?�)<������w@H�>��>7�@�1@�X?S�����o<��&@?�-��>��i�T�r�O>@�C�(O?�!�>c���yݾ?�7@��>v�?.�<>�<2�e�O>Pg7�V(�y���ؔ?�����?R��H�`���@���A�������l׾ u?�_q@h?�>9��>�%7�:�C?֙���y�G�[�r��?�`�<��?
9���J�?�pQ��Q����D�l�Ծ��w���?���>l�?��˽T�l�<�>����Ǹ�9Ȇ�_ x?z ��
�O���TX	?���>�ݿ�]�.l!?~4�>�~[=�TW@X��>����W@*4�?�Ͻ{�C�� ?��9�Fa=?6����n?%���i=��?P9I=}X���=�p�௖��~�?(���Ny뾪y}@�kU?�)�LOŽy"�p(�.yP����
qk?�a���KE(���A�{&���4?�R�?ps�=���?���**]��@�D�?!���N�i��>����?r��8*�?�?��Y޺�T%�?��A���	���?��=������@G.־�&j���~@1܅?H��PY��J�������	ω@����BF�?�Q����K�אA�I��ig#����?�c��A����@���>.������@���?e��>�0G���U�k���ɯ�>1 ο0��>%%�D~���`�@T����Ѿ�%=��\��*+����?O� ?��Y?t�?�Y�3�t>�"
����Eo��P&�=lc��c�D>Y������>�@��ݿk����L�����3��?�)@1�>.U]?�;?�n��<?$2���忨�����f?L.�~��?'�8�A����@����m�-~�����[�>�B@���>Y+R?��P?���׎���������7��G�@f����!»hF�@p��42@�ڰ�0�ɾ1ћ?��H��x�����?�!�?��n>aB�@���?x,�>2�6�
��h������S&��{�?"������5en��qe��rB��u�?�j��
�:�/@y��&�?ZZ�?�fV�?e�>��	�n̖�Ա��u�d?+��?;=���<�2��%�@���1q��7b�2�H����?���@o�?b=y?��?	�i��??��6��C�ῦ��?{տ���?����Ñ�_��@@=R���� �[?W}��%���)]�@�QG?1�l?��?���ŒW?�L���Y�������@�4���&b?����>/�*��@�bP����O��?��3�1K9<�oV@ ��>B+>���@��@���iu�&����N�MR�>��ȿŜ�=�9y�y���忲@���48�W7��A���L���?/U?��l>Bz�?h�Y�s�>l��g�پ�J[�sŽwGĿd~�>-�4���(��@�3ڿ�E��"8����%����?���?�i[?��)?Q?���=��P?W��CY#�kހ��d=%��#	�?pGC���޿�yu@|2�3���~�^��������v[G>O�?��?CUQ?��=�e`��N7�����;�G����?��5g�>�'ڿ0�]>�a��B���[}�bu�>t4<u��=�D@�_��[�n��?���?��?HК�*�Ϳ�A��@�k˿�o?����y��*��?L��=d{=��>`�5��'< �/@��R����K� @�v@:"?y�J�sD��XƐ�!��?6�ٿ�W??��	�3��*��?(�¿oT�=���;z*�#ݶ>��K@���>���1�T@�S�?��ɽ�i��0��i�[�m@}����9�>ȶ�i�9��F�@+�k�տ�*O?��O��NK�ө!@���?|���@<t�?�V�>7m���$*>�K��dV��+ ���9F<p�ȿ�?��(��>���JO>�B>��(�������?���C�>C�$>�/��b?�M ���0��ɧ��0J=�ꜿ�׈���N��׋�b��@?pͿ�ղ�)���(7�n׶?M�@!f?��?"V�>)��Yǟ�.~�������d���?z9�p�?i���bj����T@mu;�s+z��-�\��>��2��=@?#�?�͛>�Y���6��i�=�������e����@�n��C1B?1���_����@%E��_�˝�?F_���o�$=#@�}�>���	�Q@Q��?-��>w"0��X>�x��r���k~޿�Z?|j�c�ο�a@rb���5��#O?Hk�A1��n��=�jJ�@�?�I�
$�g�r=$�� �>L�w�Ł.�mӹ��<�>ϟ�縿j�@��࿖����=
��n�b�?�@�&?7�>yu�>�a�?�?O���ߌ��c�s�'�>?�!\��c�?����ob��:�@�9"�0r��	�E=����F%�D�@۹�= 9?���
����=f��Z�>�'��E��?tW&��o`?L���,`�ax>a-l��|S�� =�a���s��^�?f�׾uvW��_�@�q
@���?�I5��?�jݿ��?�̩��Ӽ>۴��L����l>�^�����W���2�>�����&@!��'���~��?Y��?ޑ��?��f���?c�~?U8>���ɫ%?�e>?��g>�#�<�=�ľ��¾C�@<�>�D�>|̐?'1F?*n��$}�w ��.�b�?�Iտ��7��ؿ#�w���?�)y�c��Fp^?�/�>� >{�%@DK?�x���>?���?I��>t&	��}�Wu��=@��ɜI����덆��nK?:��=���I��?9��?k�־/�B>�W�?��x��3�?��?��?�x>s�a>�S�np5@��f��%�?�͙�eq��A�>HΞ��x����?�	-?j�u�q@-�i>�!z�R��@)@c��������0�*l���@���-?�&��A���@�_�s��X%�?�k1��Z3���@��C?K��熊@@��?��&M��iq?���N6�-ũ���<&_!��ݿa"�@�7`�*�??����^�V��^��C`?�	?j�h>���?oɋ�}1󽲔꿺@���PW��5��Q��;Q�=�A��Cȿ��@C1�����P�P�v��N�?���?r�=��M?���?y#��-�>�!N��= ��/پ�x�?o�E�&:#?6T�E�����@0��0���n���N7��*e��#@�o�?��?YU�?t?��r?�-�����ք���@܆���b�? P��>�7�G��@m�@�r��I��?Ap�����D8{@}��>��D?2ƻ@E@@�n?ZC��aI�����˥?�����>ǉ��N~�N�@���{���m
?��7��+��?�T@d�0>�q?*H@�)?�O>?����ſ��
�Eq?iJ��Ox>$Z��I�ڿ+��@?�*�vw��N���w�N��?a�?@�B�>���>D�?U\�>�~�?{�����.��W�@�@`^���;r?�E������@�������h?��i˿qV��Y@�T�>��5?rG�?�wb?��<?�Y.������<�?y�/�4���T��V�g?��>����п�OR?��%?��=�bv@��a�Q��>��?u@d��=>%j��:ο���=�(�?��8?f�'<���q�ǿ�E
?S��=5J��yM�>̛$��>S��?�Z���d�?�4�>�T9>$�,�Xl-?�殾%�п@�����?#�2�P�˾�;.��(n��<���?����Ǐ>�?'g?�h=�7@�!�?H��>��?>�R���V�)@�ѿ��?���q���>�%j=�x��s�>�FM�􊆾�0޿R?��%>�p˞@��?����%���ō�v-��B&?�������?9�����>	�(���f?),.�h�
>�:>jb�=�±=l"�ǧd�p	@�m�<�[ݾ�ex�oU%���'�>Ȧ?���m[?l�����(�!?6$p����so>�;������+@tO��	.1��)@�<�?�i�>s��`�z�T��?��@�(��l��?��A�7�@��,��� �=C?�%��&��m�@Y��>� >_D�@��@.��o��GP�AU�e�?��>�L|����w���ؿ��AE�T��VٿE�?h�"W����@3�?��?	}@�-@��l���o��*����̒�>�.����ؾ
���R��uA�x ����ߡ�>�n�����?�kr@t	3?��?�F@&��+�2?/H���g_�Q-���7�?�t�+?�8�������AA6y=�~�չ>X����黿+�@��?�:w?�g�?ls;^�����$����6��	/�@5����G?۬��}^"�3A�:}�
l�/fd?��$��}�Mə@�2�?<[>`��@�@5�վm� �L���x�T�#������q�2��>���`�@���Ea	�o��>\����"=�4�?���
�?"r	@T!&�� R�,��,cZ�-;�����XĿ6eO�b��j���@���#�����
������?[��?�,�>?���?��J��|;?��y�5��a>˿�XR?�Wn�w�5������=D�@D�V��0�J�T>4bۿ=��� @�3�?��#?g��?i���M�L>}��=�*˾EHο�M?��ʿ;��/'�[���$��>��-�@߂��ʜ=�xe����=���?/���x����[@�k(@�~ �`1f�)��-����?k�п���D'�����>^�?hy���������~�)�k���eH@H ?F�<e��?tR?���>���_nv��M����>��#�`���GkV��}>���?p���7׾�v��u����>-��>٪＿�Z?aL@��a<���ե��;Ϳ�V��6|?��^�o
�?h�U�M>��w�]>��(��P���??/�>*����?hkR?��l�@�`@A�@��?��d_����>�3.�?J��L�5?��'��Ǽ�1�:@f]z�%1���U?��>qZK�ȿ�F2��/g��A�@�E�? 
      w�?_���1�?:U�;q�=K+`��W��#��i(�GG��+
?d��M��>3|�>�����������݌�P�>�M�>��P>*^�;�L;4��=�4ȾH,��il����R���k�>w�d?����ݚ��OǾk=S>��e>Ō�s+���>�p��k�=���>�+?H`s?Q���)����?��ɽ�et�k�¿#��,X0��ᒾۢ���՗���6;�h����?���T"?	�/���B�GK0>��$�?%gY?4�f����=�'s?���2N=��@��^�>��M?4:w>�R��?��}�wa
�G6�>%tѾ�w�>H��>�M�?%p�?5� =��R�'��>#�<#�7>�>�ʿ�"�>�	��ΕS?oU|<�@a�>(`/?�L��- ��Y¾w�ڼSۦ=��Ӵ��@�����?b�j�۽��>=��>Pu>�}>d/f=�6[�:E�>�9�?�*?��?OJT=@l��@4�7��ͯ��+�?>˯�>9o?ϟ?Vf>�b?��翖u\>���>��!=�d�<Z˵���*�g���틧���>D��>��>[&������ǣ>f�?��<��#?���Juվ�ż���>?ԑ��	����>���>[E7=j�l��y=�v�>q��1��E k�3�����2=x�4�2�?�u�>ROs>�4���5?�w,?'L���ͽ�(>=j�:
�~>R�/����\�H<Cn�`�w?�J�=<Ȃ���>Zľ��]�~c>�@?P��<��<�Ǿ|�[�t�=$�����NJ�^|>��s�!��ͤ(?���l�>Ρ�>��[<".����B���?|�<�ܷ�j��=�r$�pݾ�X��~i=��ʾ�x�>L������&>g�V?���>��>���>�0��凾0	>-�l>�JD����>���?��Ͽ�)���&f�:��?��:�����Wd?�Z>��]���=�� �_?��?'@�>��4>(>�!4=$��Y+�>�D�f�վ���=N�=�6��rI>d��,��8Ǵ>���>/����U?'��>0�>ee���_�=��.=�"�>S�=�F.</ힽ���N�	�����"?_�Ǿ�d?:W�>�;�=�b<=�ԣ>��žgn$>�9!?������>��%�ů>}2��(ҼE?$�~<��>Y�>��#M����>��i>�&����۽��>��B�:��q����]	x��9`�q@8�w�@>�쨾Y޾�%�=��a=7㗾��s?�oL>�n�����>ܱ#�qY�>R׷�ݳվ9H2?�
�e�,���.>�[���Z>4a�=�a#=p��E��- ]�.� ���\��;��Ľ�r�G���d��>�飾�o=���>���>'ս���Y?�W���T?�t�?]�>�\>��>��>��>ǁ���3
>��<+��=x"�������}��Q �=��b�s;?F�R�\tS?@ؾ_�t�������U>:�?�_�>f�?J�?�8?�^b�J�A�X��ײ�=�ڳ��1�?9�x>v\m�Ւ�>Lw�>lG"?����|�׿��4���E�-��7��Ah%�ǡ��'��>�:�$�>,3�?�eO�)Tk���u��b/?�߾I4�Q ,?dt��z������>�(�>bh
��\����>�SS?��+��>�<�r�O?�߽,~ľ�i>oV���߾'��B�1����?�,~>��?n�%�*��P�>������u>�Md�w��>�J�=���=Qο�A1���F<J��@T���>Z�y��}�>�5,?O���S>��&��e?Խ�;��`�>�I�R��DQ�a>�DA��~����'���>F�d>�����喽/�2��T��]弴����?��*�>I�;������Co��a�7�l>1���7� �.?�Zh��lb��M�������0�>@Q�-�->�����-���<q
>�>��b>+6߽�9p>�ɾ��{>j��=�=�s^��>�<D?~�m�u>]������=ki4�4I;�U��;��?H��bd��@> ,�=�x�>�/����~>"��=R��G%��d?\�>��?\�>Ľ�?tT��a���N������1����b��W�����Q?�[?�� ��J/ξ�wؾ��	��U�>���<f0>��7<j��>3��a�X?~��?݃Y���>���%���̽�EI�l�O�;<?�M�WP����=Ǿ�>��>�Ͼ�+�\G�>8}?��¾��s���<>�VV?òr?Z'�>�?�-�B6=�E*>�?�׵?_����,?�j�=�N?3����Z9?$��<�9>�R�>��>|�>�~�>;��>�R�>���=�hƾ ) ?%q?�?��&��<6s�<�>��پ�-(>H��>3H�>�w�E��=�D�>�ƾ?˾F�_?��>V�F?鵧�ݽx��������*nK?�$j?P�3�Ĕ:�&���*"?Vok����<vZ�>Cɖ>:����u��(�=,�������V��+]���J��4�L� �լ����?Kq���<�4F=ܓ�>���������+H��>¾�·=h�q�)�	>�N?��=�ྉu>��l=��O����c"?Y�c�MB�j)>�S��=��_��=�]�>8`�9��>ܭ��'8�>2�~?��f��Bq�~�#��=yc�߷���Ծ�ֳ���(�hĊ�9�>>����$?��>}d�>(O��X����{?�??���?C���#-�?웁�8Q
?ҎX?F���[;#��>�]>�>@�@{0�=�H=�.�?�k�?�"a>�9��p��>���>:n?b��;#�!������x���>�(?��?�J����X=\a�>�1��p�/v���=�>K�>�b\?	C��%�?7�|�}���]�>*g���ϾH�?�6��:̱;��>��?�?9>n�Q?�b?	FK?9U뾹z��Ls>)L:?�H?O���Z�lAG>�/���?�ma���=E�>�5?�\�=����)���5��h�	?z�׽j2>p�?��?�
�p[����yn�? ]�<:2r=��ؿ�j��ΐ�l�~?FD���t��f���>Oz?�\�t-U?|>*>��=�ʼ?7 �>�m?�s�>�E����k?�����%K��P���g>�;>6C�#ax?6	���?M�E>Gw��vu-���>?�;3v?�#���>��t�_*�>T��]r{�N9��j��>�b�����E?�%L�0���{��>��m>w!������Q?��ؾ��3��ԩ>�D����o>qf�>�7m�
#�>���>����W��>ҽ$��u�K��=�)�>���'?PP;�?����g����?ӱ>���>��G�R���|���?`W⾔�?�t˾vpپka�=5�?�?>��>��>I.�LA�z4?=P���k�Fl��m`g��F?����Bd��l;?��=�(?���>�����%i>�-��3h���\z�8�%���7�tp�>Y%����=�֠>�-�zo�>L� ?+�Ž�T��I�=�-z=�h�r6<?֖˿�|��P|��C�?�=�t�>g.y?�F?�v���9+?6-f��+>c������>���>Z�̼䍃��,D>���Ⱦ_=��־K9 �G˾'B��G��>��@��2E�?4����">���>Z��>b�b�UžА�T�4�H/�<�~$�_�A>�;�o�>�Ѿ敐=�"۾"d��H�&>z�>9Ժ=���=<�>n�;���c>?}�]�]=�!پR*��IK>�3 >F���\���N��R=>3-�Q
��`��^���Ō�>ق<���ɾ�`���P�����>����m��>U{:��Y��d����"�?#3?���>��12�>��?h^0�l� ����E7`�5`��I�?cA�����۾fS����p?�P?2+�'8K?s,?J�>�Zc>u��>9(�gnc?����E���;?� �m��Ϫ�>=hV?G˹�P?�Qe<D(@?Z�Y>W1g? ��Ǵ>���? À?������^���>0�?T������@͑=�����͎?���1��=���>�(���Ȟ?>Y�����BT?l����?��޾\17�5�н�Hm?�TX�a��>�+?KD?#����>��!?�+�wӽ�κ>5�>�q�?�@r������A5>�g�>#�Ev�Z�¾�u3�{���Vh�;�o����?p���gu��'
��x�?)F��/�ҽ���l=�?9;��|��?�Ŏ>��>)�*�W��>���?v?r[F�b�wKP>٣>����9�?�# ?���+蝿M�����
��1�>�H�<V���h��x�>|�t���e?x�r�'�ƽV�v?���!R�~�?(������W���> '?�ھ R?��s��t?��?��������~�.�z��| >kgs���i����mk޻�����:�$�پ�4�?H�k=U����,6?t=��jj >�����̙?f꾰�?]��>f־���>��?���O#�?O�?�M����/�0�)�-����d��=��>?� ,?�j>����F�>�2־�<+?���?l����.4>��?�O��ҹ�==���%�>Z �5���%кW|t>�����>J�۾�ݮ�~#?�t?A�7>mÙ��e�=�#�?0�����>H;1���_�6�(?��?L(2>��y^�>J^����:@2�[?濾�{˔�En�M
)� 5
�a�����5=JŜ=��|>0I�=6�C?�Gݿ�Ч=�	�lԽ�y���r�����Y?��B>>[>�F��N��=�-?���=^����		?-�a��_F�=�+?<i�?{ �����?i��;P�=2���f!?�ܕ=[I>�E�=�1 ��~���>��3=�#��b?C^�>��?8���d���>-	����X?�/%����TJҽ�0���>#����� �z�?G��nel?3�=J>��$|��+˾7�ʽې�>�r�>�;�>:���I�>��z��h�=z�W?�^�?��=�?�F��>��/�q�?U��QQ��n���GV�U��r���GE�o
4���>�h5>�d?z���Q>�c�>*+����,>mݎ�8c
��ht��n ?6��c?�(�����G���M���!?W#>��?/&�?�!�>��?i�X�,��ν�{�ů�>�Q?��r>�O���[u?	�̾Zr�(q*?��C>_>C�./�=�	Q�}t�?��ƽ	x$?W�(��-?�>���Z���B�?-�=����+k�>���k��=r�U�������3?<�&?�`�%��U�>5|���,������?�1%����>g4?��U?ڵ9�#a>-��fԣ�?�IR>r�2?����b�q���E��#�>f�=!���4�>6َ?*��=λ�=�St>��9���=������=���\�8?�>K��<d@?��=>��<���>	�F���4��L亊'N>W�=�Ⱦ���>+�@��>>%��>\��>6�;�/�ɾK$�>{?�Y�Q��=wq#�k�c���e=Y<?����c=�1�>Q�`��0�?��,>1ڷ>��f>��:?� {?�?��(�걾�?x�?�4?����8 ��x0��X.�?��?j��>���u�>��>�+��^84��;k?�,��IT�>_ܽ0o��!Eû�o>S�ʾ��?,�Y��R?��m?�p�wS��:+?�+���@��c>I�?���������ѽY0��9L�mu^�˟??��=�6�>�޾^9D���
�91�?EK�=��>�J> N?���I�"?������l�1�X�I+$�E`p>�C&�e�\�r	D���=�A�=d[�>�� ?���Gd?r�"����U�=�����Y>g嶾Ǧ?��=�����>j�&>�N>;�>���?g�&?���>I�=x�7s˾p���}*9>���>��J?�~	��H��Fp?w"�>��V�>eX����侍x��%��*,?�<?-��KX�>�V�>�(��j*?���i�>��^>�9�@>�[��h��>��<?6p�	bs������h��,f>��?��c>9��?'$[>kl>�N�=�,���5���X=:?Tz�#�(>����-"��`���0��r+��/>#r>xu�>5Ϯ��*P>�m]?�"G��� ?O�|=Ƕ}?ə5��H>���X��9��?�0���?�/C?s�=�GپI<T>�H
��e���>�p�ƚ����]?,�����V=�����d�<ܣK?�ѫ>{�F?�H?;_?A#�W-�>oTf?L�ؽ��4��?�R����>�%���I?m���>�3�<�Qr3?�P	��Ê>4/��C�5�S>a��W=|=�T>�*?q�=f�+?Er&����w�v��n?�CI>'G�>/��?�B�Oo�-�>�S= ����K?������w?Q7J>��>�>��i>t�?.�;
�\VV?�9��^ �E<�����\��=�R���\Ǽ�i�8�=�x��W9><#���<���>	+�=8�?���>v�x���=n�,�R�J��:��%�=��?��?�Gk<��?���?R��>(���P�>�Ƚ�_� ?�8��F���a�>�5P����>�"��lj��3[�hآ>��0>tF�<G�e>{�)���&>Y�?t	o��d~�*���%���Ha�=��?M˃�t�?��>��#��ࢽ>pM�m� �^?Mc ?#.U�k�n���B=c�þP7�>�!�=�h%�̵�>�lB>1$s���x�y6�?���;X|0�Hj?i�>�wK>�S+>vU��PȾ^�}����>�� ?�W�?�/=�]������׾�Y>��d?}�a��?�Ӟ�Ж�����>$�#>J�ʾ{5�>���=J8�>2H?��>~������$���9?H��r�?�"���>���>&��HO��J����v���!�>�h�����>dz�>���>n3սӊ� f�����\.�>�p>8����Z��s��=s�(�ϫ>+(l>�۵�냾�3C?��>���>��Žپ�^>��:?������I?}E>v'����>wg�=�q��'�>@�0�d8n=���=C����4����=yf?7�b��l�?�<=|�.�lH�D.�>��n����>Oa?�f�=H�:O��>$a>�k?|���9m?(]ʾ�P���ޟ?���==��R[9�^�>����F$���`u>s���>���|@F> ��A�m�C��>>��>�>t?m�5?�78?��"�!�>�̷��%P>�?�	(�Z�i?iù��@?B����I�t��> �=�k,?��!��#?����}��m���?�X��i~>���<�L?�B��b�>D'�������g���������4?w|Z�rWr?�C;��P����=^�F>��%>Y>tޯ���=vS>b0�?����>I'?��5?��B�Cl�<}H���`����y�=a�M?r�7?�k\�Wf�?)߾�0�Xg�?�)�����㣾\(Ⱦ��L�a��˘���?<���>䄽H��=W\�h�>��>����T�>F ֿ-6�=+�(����?y�>b?��? �q�Th?�?k43?@�?�L���ME��U?�q?�����c;�;.��8:>���Yf���T?C�>��ѽ�ԉ=��<8|�>���>=��Rbμ��'�b��I?�3�/�޽��]?���\�=�v���
�?�;D?�s7���V3>���>�3����?+
�>���|���4ʍ�o7?�H1��>�E�$���u��?��x��X����������R�^��d��I�a>|}��#�vG���ݾˬ�>�u������m�ӥ�(Ԕ���H<]9P���>MVe��F�>炚���5=#	�=ys>�I��	��Ⱦ4T�>�?w�E>[P�����ݍV<CG>��H�>���L�ڿ
H�����/o?�x����?�2�͒!��!�>:鐾�n���A��3*?~G>T+?e ��(���A��|dH��8��}
�����>ی��+ˁ�	���G����˿�W�?ô�>Z}�������#���M�7�ERվd������?��]�#v��s�y�ӯI��N,?5)�>�h�>���+���v�"��>��<��޼$}b>�|-�O��>L�ƽ˜+?�d?E]>ӦO?RS��z��<�]�(��>#��>�U�e���'����ӿ?d4�?N'���u.�@5"?
T��v���7��?�� ��=�
	��PY�ۗ�����h5��ì��G���Q��1?��>���>�Q�>�\�u�?Vt��;ѵ=�v�>�翿0@Ӿ�VL=�v}>F�F��JS��^�>G�?kh=�[^>�L�>EL?>r��i�>�r-=F@�=���;G��c��>� �=F��?�U�?���?��>e����>�#=��>�N�w��>f��>0$<?��-�D�<g�?*�*?����>/�<��봾ƸƾV� ?�;;���>��<�.��܉�= ��?PȾt��yG�2��>Z���n > ��Z��>�f���8q>",�� ���a<T�\?;��>3�?�&���A��?�n�<�=��6?���B	��>�>�(�92��>��3?S�?��t?��?:DS=����?x�s>�;>nA�=��=C��?�%���{�K�;>4hs�0�?�%?C�> ]&��,E?.����>7I�ל�>��A?�/?@m=�Kڽ�=2���>Ÿ�>�TϾ����f�>�%?'�9>L�]?"���Z�������q����r���ʵ<Ǎ?�`?>�
��Q�>4�4=�׾
׽կ���>ޖ9��G�����e�>A��?* �>x�޽O�x(I?���?ާ�>�:��!v>����0?�y�=8���8
�������>T7w��7r���D�P|Ǿ)�&��ŝ<���N�L>����+��271���־��>��>�‿� �>���>%���/�x��z�>�ힾ̅��"�?]���7�>�R?M���]�>\<�ݏƾ{+���t=V*�?�⼽���\ȾK���r�>�<? �ʽ�4���?*�
?���>��M?G�5߾��_D^��᡾J;{���Y��V'=��?LUt�`�?[�V��6?�����>C?�KS?���=�F?�cN?q�?6��?����q/?�ji��O]?a.��ao���#?N���&N?���=?13?�wz�,~�>�ѽ��?�V��1�?�M	��1�=.Y?�y�<< ?��<��E?���<yC���?o���;�ľ/����3��7����%?�ݛ>m�>Ug<<�1��Q�?�@�>�[7���V>?AA�[�?Qþ�W�>r(s����iE�/G?�?q7�eȽI�>I�0���&?�Q?����bI?w�?��D?�[�=�Mu>��.����KX���>�1>
���Xt	�lŦ�?���i[=�d/���=*���Z+>G������>ԫY�o�D�ܔ��Z������>~$��⿾�f?��E��赾ȉ=���>�Ծ�5?4�Zx�� ��'�u>2Z?p�ӳQ��oξ�����/�=s�G?ye?��+?T���J�=Bw�>��l��Z0?U�j=���r.��q� ��I���9�>?ڱ?�d��9?�E�T��>�Y�=�
?�Ԑ���${k�A���IǠ=����d�=S���>�>=6����;�2��>
>��Q?����p�x�u���-�/��L���i>���>Sﾬ�7��qӾ'�F��[D���?��1?�3	?*�ݾAi�>A��>̆>�u�>h���g��O2�?J���O?�b�?s�?T��?9�>.νiɐ�6P<?5�оL��>�<�C]��(�>뢽=�xp>�}Ͼ!b(��X�����?kTP>���>��{�D�T>��?�u?�KC�,e|?NCF�m7?���>!��>����j�y�>U��X�������aE�>�����(?����D>��>[�D���X=X-�=n߁>k=Z��E��)`M�4��>C���ɳ>�K>5�j>����힅>�?�,JN�M�>�D��@i�>����N��J�V?N
>\<><�X?�1?��3�G,��̈���?P        ��<�L=)����?i/�?�x?��޾ B?�� >��=�d�>1 S?,P�?��j?�'?Y��nv�=	<�?̹��N�?����=<u-���*>O-�(-�e��6ݖ>t����z?��*�q��>/ep�q���A�?�~?<=z��E���h�h�@�ֿ5� �Pj�?��?%+?�����?��>+r?�?*���m��?п8?�[�>K�>�ma������<������}���r>@�>y:�>U��D�D5C>��?U??���]9�?�a��ZHb>3�T?��?B�?NԞ?7n6��?���>I��>)�?P       \?>	N>xԾ��%>�+}?��/?�]׾�P?��=3�4�6�h>#�?ύ?�7m?�q?������>)پ?����k�?o"�sd������&������	
�|�<���>BO�ԣ�?��H��ļ-�>>$ä�8�o?��H=��ܽg���ʆ�0���tj��*�?�p?�?�>��_٥?�Q?̦?�@�?����k#�?��B?�?�>
$?��T��h�&$>���8�����=�>-O�>#+Y���.��:>�R�?G�K?��D�ԣ?����:�?}��?�?,��?�%�?���O� ?�#?!B>O,�?�
      m�`�:/?�?�?1
�>ǿ��T�?(d�>S��>ģ���h�/#�?��u?Y��<�km>�|*?s�?������x����==M2��'־g���ŋ>}n��>���C?D����H��.,_��;��m��?�:�s"��w҂?ьs����=e�?�zK�/ϰ>�)>_�?sQ?F
+��,?��@61�?E�W?��?�T����Ŀ��׿��1���?ș3��>o�G5��7?b]ѿ�9��-�(?�����ҿ��?���V�?	#�?N�ɿ��^�ס����o�S�?�_�>�++��6d?%[��e���,���俙�վ �#>s������?0��>2���/�>P���V`ݿ��J?��4��t��a���}>��F!�T
@}8���1޽�u�>��*?l�н���諿$ֿY5?�rz?R�?Zew�0ϳ?o�˿�	3���>� ���^���Zs��.z��W��r>>�E@C���b?�� �L�y?	�.<.���#=�|�>�	�?�,g�U�?fӂ?��?�X���=�~���.F��m%?�0���>�	�?{����`ʾ%O�?>狾u&��Q�GĎ��pS>�t���χ?�V��?O�����������Ѿa��?��?�->�?K&��Eu�>g�?˕�?(.���6@����� ��ȍ?�m�?S�?1I'?�@�����n��NY?OV�;A�z#�=���>�&�/^�?�4��)�˼M(@�������^3�6�>�|�?h%'=�@Ծ��V?<b�����?�>l?��=]�=����AԿ���?�i�?B� ��LW��L9�|�¿X;>��xܟ��ֵ?��>8�?�P�����D6����F>��?l�?��Q?���>}�ܽH\���J=!�?n��?�*�������?}s���sN�>l�!����?X�t?��N>q�M��=�e5�?f� ��2H�{���o�>?=l��̦<=����6?���?���?�K�?D������Tmk�#"���%��eW@�-p>���=���=��?,����>_'l>J #>��v�R�!?3i�<�>g�?E����~�o=�vӿum�3ⲽ��佃V�Y�꿳7?RH0?�D��Wof?�#߽�������?��_?��?.�!��Oj��������]v����r�B�_�!�m�Ǹ�?��%�jh���Dy>�;��l�>~�?8�Ϳ��W�dὩ����=��!���?r�	�y�b�5\?��޿�@F���x��~�����\r�?GN!?������<���f@����s�����>�r<@N�?��?�K
�-2�>��ѿ��?��>���ww>�e�?4�����d�����M?��/?-儾�'i��{�?*����r���9ၿ�*��0�c�o�®�~�����>	'�������>,tX?��4=�0_�f�U?��]?� ~�"Z����E3>�����71>�C�s����e->��(=�?��;)j���8?>=���ۈ�>A�>��=6�l����>c�V���m�N��>a��=�b#@�X���9�%F�?�C���?RNҾI�-�i�=?��p����?Xt��-ҿu�>}h�?l�S?,Lf���ɾ����>kq�>G���쎿{�?)/��R:�=�{ܿ\y��?���=��?v�@>��S�>"ʑ=?�ӿh ��yR�>-˜?�V=>��?��=��>��/��տxl0�b�ؿ�p������	Ծ��M?蘅���}?�	�Q�ӿJȭ��dݿ7.@aR��·?YJ	�Ӭ��?k>�>�Q�>M��W��U?�/�>�q��P�����U?y)a����#Ľ�m���ʾƄ��(��0���豈���>æ��k�?�꽾tkþ��>/�>��>18}?V�?�ν�i�?
⌿���>ᶵ�I��?B�~��� @��Ӿڌ(?�b�>���?�l:��?��	@iς�n�ܿ�n�fM��	�J�>Q��C�־��7���8��D�^,���ο��I?��>��>�?����\�?��p?��r�\�E?68��{Ҿ^��?/f>ƶ�t�6�>f@�i������5��t��U���)(��~��֡?X�M�	�,���1���ݿ�̊��i����=��p?V"��g?㙐�ĳ	@��q:�?\��ׄR?9���- 0��)�?�p���0�K�̾��@�a_?��>�Ϥ>��-��V8�~�����%�xg�P����?�r>�X �L�z��"���C΀?7�k���T>b����������� �-^T>�ܐ?:T>�m���M�J�3?�K�d���=훾�a@�s�DA���z�>sɴ���q?�4��[��-+�c�4�HLA�B޽g�?�����ʫ��A�?�u>.'?`<@��п���=oA>!�I�h͚?���>d�?�� �[����ka?�,��Fy~����S�?�j���>�S��=AyB�H�x=.T=g8������0����g�=�&%��k�>|�>��7?c�O?�n*@@�?Z�#>����u�2F�?t��.�Z�?���><_?L��0{?���?�n��}{\�H[ٿV ��F�>�Q?D�<��Qj?�,_�7=t?�Ѝ���/�pu��^�D����>��?,j@���?{Q��L+�?�z�?����,���c�?�T�? �k?��y?=��?�O��s	>�Y]?��5>�����޿߄7?]"�5ܫ����?U�>9]����?���=��??�?��ѾU�#@�+?HP�^뗾A�=�r��%�1?�7����>�y��p�=�@zྣ��=��Ǿ���H����C>MG>�۽�b�x%�?��@��=��W���%9�j0�?������D�W?�*p���?����4���> z>
���A�?�E����>v���>��J�b?�z��/h��<hL���	?��1�䨿H�>V]Z�9Ĥ���@�g�?����t���=�>�G{?Q�f�"�齑߼zI��P?���e��=�Y�?S�I�=��UW)�Ǻ&�I>��=ƿ{�׾��8@�ɗ�Oi����f:">�p��?�X��<��>~�J>@+??+~P>�a>,-������B�O?�>~��P������?E���.9?b���ο[O$@`?�O1?��@�c̩��J����U2 ��@4>��`�ƾ>�*�s]7>K��>/!�>���>N���g�?k��>۰D?��>�`�?�h뾊�׾���P?�#h>'>x?1a�� �?J�>L���D$��p�� �T?t�O>ȿ�>X��>RO'�t��Wq/>Y{�?����dă>{�?�^��*>�P�?P����?h�?�Ú�dtB?��ֿ�>�疾�LJ?�+�=�褿R���rP?��_�p��`�>|�����<�H5����,�=�7����?P\��2� ��&?�ɓ>��}�5�>��>����[ÿ��=��gN?�G�>d�<k�?�����Y?_�H�<[�>lD	?8��=}-����= �;�Ҋ?s�V�$��=j��?���a[J@Ur�������=��I���Օ���,?��Y���[=�䂿�=�?�j�?"�ƿ���>쯍>�?Q&r@�`$@ߊB��x�>g���A�=�	���L�aK?���?K���G�a?L���K�?T��Yڧ?c�]�Y?ʫ
@쐿Ma?:￲�\�Hh�?d�о���vj߾�r�>�ξuϐ���*=�,��n�?Q�����>q��ɱ@?=\?��>�_o?�rC?���>]f�>I"���2��}^`?�ľ/���o?3"?,k����C?U�T?�S����?�Ծ?����Ȧ��r��g��N�&�?{v���%`?y�4>ނ�>ګ>�.�=^l@�om���?��l�����>�x�Ki�%F�?���+����?nI�?��y�����?Q�B>�U��y�?��˾���>)�>�B���aA�پ����A��ʣ?9q-��_1������PP>�H�=���	kL=wb��g�I�?���>?�u??�4�hc��,A��F��G�=ꚵ��~�/	�=h�A��l���Mv���E��q'��-���>��*�����U�>��^�a��9����4���� �^0 ?�#�?�$�p2�>$p%�]�:�d��>��!�3\�?���?�t�>����t�$��>������?��&?qqv��J�?Yú���3/��f>*?*?��0��=�=��!�F�g��|ӽ�C�>�V�? j>P����?��=
������[a?���k�?u�U���c�D��psY��;J��
	?�
?�
P?����bA+?�\:�ӪW���?	J;�@�>�;�<>�n�oIM?[�?�A澷w�� <U�	�>C��>�� �<f�M+��'�>m�J��?Ǜ��sK�?(a�k�(;�җ�Y� ������|�?}�<�r����r>,�E�Q�?�mپ�w���"�����ڵ���?>�,(@� .��C�>���>&N@4���₿��?b�翅�=?�xt?%�y��侦�½���>y�;?SA�>��'�h�����4���>htw?��<���?!ÿ�I�>@�����)>b��b�?ru޿Ru��?}�?���>E�U��uN?tZQ?m�F?���?�=(]�?3ϿGzлL	�ƽ�����&P����?�}��t(�B����:?
��>v�>�p7>>��?�cb�?*y��9�?g�y��ee?��u�:��?��`�O��>�˽���>�5>�Y$?���&h����G?�N?���?�f%�S��?G^@-@M?�ǀ?A��bu@�r��۾��l���?�@�հ����?���>ہp���l=R�v?�p��ǧg�"�?=D�=/�?���?���?4�?=�?{�?]��>;�b?~��?��u���Ƶ8���F?�v,��m�$�?"\%���=�/�t?�ޤ>L����H���Z��6�>�ĥ������� @�뿰���"�����3���L?4���@
>�f:�-/?�S?���GH=?���? �E�s?yQl�y��?��(�Xq(��w�=D��>��s��S	��i~�7�=k��?M�+��7>@�￼!�!;Z�p,�<����-�r����4��'?c���V��>m �٨X>Me�>��>nx�?�M�>c:���i���ܽi:�>���H��!>@Q��@�a	��vF��Rཱི׊>Q�
?�5y������w�i\?$�>"B�?��?~�=k��?7��>���9���G��%�N?������>��?�Tn�q�+�=1 ?踃?�X?d�����?�ٹ��a�>&=<0�>���>W�Ͼ;�����>UR�=�� >�^��ӽ|?9�=-��>އ��i'>m���q���J?k��?�p>� ���?��?�#D�s.;?�H�m2.?Y�c?Vc'?*�f<	�O?�^)��h���H��WD�?,7�?O�4?D���0���/?�:տ��?���-s�&�?�/@�G�<4T?�U��$#?g!�$Qy�����m@ʥ˿�V������ܾ�?�?��L&? ˀ?n���Dh��������8(뾑O�>f�Y��&�?s{u���a�ĵ��\]�=\�x���U>����(7?kYھ�P�?q�P�Q�8�g��'ۚ����,���/9��{2��<p����?���>e9K>Ji?�wſO�ҿ6�?�԰=�⟿X�>w}�?�&u�C�>0��>��پ�h�?��N?2ؾ�Gѽ�o�?��޽�=�rz��ʰ���4m>�?�U�=T�f�V��>Wy��C�.?��>��ڿ���>C�s������>�~m�{�پ�?U��=���=�O׾��?�9���������[��xϿT�?�V��>�R?+Ƕ>�Ö��ʻ�䄫�U�F��b���{D������>����W�>���>Ah����|J���ꮞ?�<?��C?�l���ܶ����?鍿���>���>|���/r>L�?��_�@���-&�������g�&���3��^?	�d���i��^�}�>��L?dYG?�>?�X�!��?�lE���࿂��?4�=�r�=�����>C���E`@tI�>��?9eC�b���O߾"�>3�k?�Q?<�����?��=�q�?{��1�ԥs?�|'?�X2�ȐӿL�/�ܮc�SP�?�>Y��>��@���?W����ci?�Hپ|"@�����sH�ͅ������Ƞ?����:�,?ǩ'�, ��񴑾$��̐C�t�E> �
?�%?k=�</v��4�>��������!a��~&Y�XΒ?��
�?Vr?�!ͻ M�?Cj#�V�U���⿏<v>ZDM?�������>˽�>H?����?W�9�U~>*���*�;�L�����Q�hYe��r���]�=T5򿻫�=�]b��ܸ??N�G>���X����]?H�]?�`�ze�?��o>_GN�sW7?�f?��A���:3�?��d�?^���I�0"G>D���y���+��*|����>�����t?R᱾X
������Aw��ʵz��M?CR?�i�>��?Zh�E1:������5�a�8��������M�<R��ʯ׾޷�>M���%��u�r=��?T2�r��>$��?��V�HPq?w_�=���>׀�>͎@�R�=��?z�?�1��T�?��M�A?�R�^?�ă?�t`�)�>��t�^�?j�~��3 ?G�?e��~P�>��3?�0?K2�Eb��EO�����D;Ԝ=P �>S�N?Z�?4Ո>K۶�ez��I<,?�z%�6����ξ��ۿ�ɽ�6>=�K>�>��\^�	6�!�>R��?�>�l��j8��/ ����>��|?����I8�6J��qf?d���h�?��׾$�m��w���*�=	0F����>�v�?+�r?9qQ?␽0��>U�f>yv>�`0?NQ?�F��@Z?�������󼪾i��<�D�=΅d�(��>����D��$?)@���O��F�>?�����=���bJ���?��=!�,?�˹��n�=�">s��a+�a�r�Ń>L|W?OV?Q�?�<�>+3�?'ӄ>�cp?8�E��)�����Z�?3V(>�����?���9�g�U��1D|?-��>�?��=��f>��:��p=b|Q���>+U?ˮe?C���/ؽ�)�<Y8d��.��X&u?ڊ���_[�,Y����i=�t�?�d>aW��X��P�D�꾩j�>�ᒿt}(@��?Qu�?�b�?��>�s�ŕs?
J�����|"�����a�.?x��d!?痓�E�ʿ/u�?b��ڬR����V3�?%I�>q�>��?B'C>���R��9?���>u�&?��>?� ����>oY��k?�?5A"?��?8 4?�����>\w�����-Q2@qũ���'���>�Ĥ��w
�|��0,�2<������\DP�s=s�g�8��?��>��t�q��F��J@п�R#��h*���:?|Q?;��?���?6�?n#�>�^���;uY�>\�{?Y땿oҤ??��?k9?ż�<�@?���4�n�?�V\>#�ѽ���?}��=?u�=�K�:z�?VL_�S�C?pF;���(��Q�9�'a?�j
���c?��%�J@���c?C(8��վ��[=M�7��L��\�>���>�p>��g�Yf��ذo��!�=�D>�[L?������>,ݰ?�W?MN�:y�H��u�?�h�>N�̽�zҾ���?�_h?>*�����v��?��&?��`�$ _>������9���4�?����5r�i�?A�D?���=����ܾ��}�{��?�d"��ⶾ�_�?���?	�M�X���
h��ڍ��`>�����^?���B�:>(�?R��?M��tc�>S�?�����=�?��?+��>N�-?�Q����c>!��#�?M-�>I@_?��[>�B!?l�A�W/��/d�>�6��*f?�&@�����䨾��B�����*7r���'�Y˿p`�>��֌R=��?���S���<I=*�?⦄��᤿�]6?�m���­=��?��U> �G?/Lc?=�[=��>N�R��ھu6r�Eo��г̿H��?j�]�MM=�4�?ƍ�?�❿�W�?���ā�>X"�>�:�/�D?s�8��ڏ>�F<@�c>}政�x��e�?������?��,�u�1���>k\?;��?�\x?^f>Y(��G�?�贿�o ��+��D?��&��(�?<*5�2{���������bW�h��Jƿ
��>��>wFF�,#%���?�Z���\п"9�>�4�>ةU�[�l>��*>���9����ٴ?|�D?4��!҆?��o��@��` ��^>�p?<Z�>�K �:��?�%b�����@�>�=���>]"������X���Z?��o����>*�ս_��>Q�b?P��we?Gތ?�[��{�?���f=J+�>��������K{?gCy?�(���>?��)��G� A[>V6����N�*����娿I�B�]?^�>�p�>>��?t]��
�P��=	&�?�+?���?(˾>㙳���q�XJ�<�?��M=���?B��?7������vE���5?��x�?�	������R��=�2��T�ݽd�=�f?���>��>Mr�����>\��?s7�r}��68�hv�>��>?CG���`"?��>f��u&>*Z�>k3��R=�(�>�@D��?db��+�>���>��&�,1ɾ?�o?��?��f�
��=��1?�?�MپXF�?�I��O�O?Jc��U_?x;�{���?�(V?�I?�m>W�"�����6?H(��ߕ�>������o����?(�����j�+�O}}?��ҿXy��oބ�)�)?���Nh�?&�$?�i�*ڒ>���E�>O\�>�xO?x�d>'�>���y����?��>�Fx?^Y2�Iph>"󛻙X�>�<?r
�_���?nȏ?�膾3C�>�2$�?�F�F?��Z��&9�,� ?�I�?�r��MQ?�-\?W�<_�:>�J#@��>��D?�2?�Z�=��?��F>;���#x׾�1��h�ݾt�[�#S����?cr?3WA����>ɍ?�m��⁾���?��\=�*�=5R��AH��֜�<qq��U��=�P�?��I�'��[�5=9��?ɍ?L�?���+�?�>�4<�N�X>C�>�FO�G����s�>������>CF)?P/߿E�>~Z��{Ј?M�2?r���V��q�?g�`��g�?m�F�T�@��E��:]�{˰����?�?��?�0@��S���?���8�>���>���?_oÿ���=��Կt�����>qs�@�J����>���҉k=a��>�@��*=Z"����Ke?��U��|�>�& @X��Zܿ�����$?���^Y?|���� B�\0�>񿸿92��y�A?&`g?j�?���$���i�n����:�>W�2��"=��^>s�?,?�#��>L���;�?�o�?�?�?3�W?�v @i*\���?u�=\����ÿ�b�>�z�?r�? ǿRW�����*�@�J�?��?���?�e�m_�?<�ҿ�x����?x����?��@N�{����>@'�@��U���[�����>�"��#���ɉ��?��>@��u闾k��>�ͣ���"@�K���)"�*�K��]�>F�?=���j�h��(?��Y��)B�>,���
���Mξ���>�P����g�Xe�=���=�e?���>t4����ǽ��D��l��p갿�d�>R��?`���d.?�ޅ?��?Vs?�1D?RRm<�����<?��������������-�X5O?߬�?3Ϧ>f޼=j��]�2��E.?t�e����?JP���}�>0[��Ff�?�c�<��>��?_]�?����t�ξ��4Ė=\�"�`0�?�D��0�������|鮼�0?sr�Vp=xt��0�>P�?�
{���H>"V"��Q���s�/�ܾG?y���7?�P>��(?J�Ǿ�|��CŠ�(��?�@�����ȕ���>�s,��$����m��O1�y�¿��?{�p�-�B?���c=�x���>�
?ъ9�q�?���K���ؾ�4	��'?�0��;��&[ >�>-?�<?#����$v?+�3�����]H�w���J'���?���W�?��>�7���,?.0"����6�>�^��l-5?��?��4?�F�>��?0A���-�xR�A�K>ɡ�>>�����>���>0��Ԗ�?�19?R3��IG���'���ٿ���IǺ�u�@�4>�d�?�)Z?*˿?�$@��@p=\?�͡>3s���(�>j
h?�	Ŀ�L���-�>y��p��?
��?����ؾ���+H �����  ˾=f��!h?/���P����`o�t[��l�D���h?�r�?�*���?a�>O�@#2@-�@��?D򖿡OG@]���N�?cC�=��g���b?�3�?>��?`�B�Б�?~s��� (@��>�Â?Q�����S�?��"?F��<�SI?]��<�)�I��?����?j'a��Z��S?>v)���4�Yu��c��?{�^���0��?W����%���2l;?#��� q�J߮�9������@��}�����$�kX�?��?������2����?�L���?������?<C˾� @>,��v"��?��ܾTR?�����>���>��:��瞿�MQ?�@����l�&?��ٽb%�0�b?��?J>��